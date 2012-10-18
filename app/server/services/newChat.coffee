async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'
getAvailableOperators = config.require 'services/operator/getAvailableOperators'
getWebsiteIdForDomain = config.require 'services/websites/getWebsiteIdForDomain'

module.exports = (res, userData) ->
  {Chat, Session, ChatSession} = stoic.models

  return res.reply "Field required: websiteUrl" unless userData?.websiteUrl

  getWebsiteIdForDomain userData.websiteUrl, (websiteId) ->
    website = websiteId
    department = userData.department
    username = userData.username or 'anonymous'
    visitorMeta =
      username: username
      referrerData: userData || null

    getAvailableOperators website, department, (err, operators) ->
      config.log.error 'Error getting availible operators in newChat', {error: err, website: website, department: department, operators: operators} if err
      return res.reply err, {noOperators: true} if err or operators.length is 0

      # create all necessary artifacts
      async.parallel {
        session: Session.create { role: 'Visitor', chatName: username }
        chat: Chat.create

      }, (err, {chat, session}) ->
        config.log.error 'Error creating session and chat in newChat', {error: err, chat: chat, session: session} if err

        showToOperators = (next) ->
          notify = (op, next) ->
            Session.get(op.sessionId).unansweredChats.add chat.id, next

          async.map operators, notify, next

        tasks = [
          chat.visitor.mset visitorMeta
          showToOperators
          ChatSession.add session.id, chat.id, { isWatching: 'false', type: 'member' }
        ]
        tasks.push chat.website.set website if website
        tasks.push chat.department.set department if department

        async.parallel tasks, (err) ->
          config.log.error 'Error in newChat', {error: err, chatId: chat.id, visitor: visitorMeta, sessionId: session.id, website: website, department: department} if err

          # set cookie and create pulsar channel
          res.cookie 'session', session.id
          createChannel chat.id

          # respond to visitor browser
          res.reply err, chatId: chat.id

          # query for ACP data and store it in redis
          populateVisitorAcpData userData, chat.id
