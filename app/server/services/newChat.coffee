async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'
getAvailableOperators = config.require 'services/operator/getAvailableOperators'
getWebsiteIdForDomain = config.require 'services/websites/getWebsiteIdForDomain'

#TODO: implement as required param
#filters: ['firstArgumentIsObject']
module.exports = (res, userData) ->
  {Chat, Session, ChatSession} = stoic.models

  return res.reply "Field required: websiteUrl" unless userData?.websiteUrl

  getWebsiteIdForDomain userData.websiteUrl, (err, websiteId) ->
    department = userData.department
    username = userData.username or 'anonymous'
    visitorMeta =
      username: username
      referrerData: userData || null

    getAvailableOperators websiteId, department, (err, accountId, operators) ->
      if err
        errData = {error: err, websiteId: websiteId, department: department, operators: operators}
        config.log.error 'Error getting availible operators in newChat', errData

      return res.reply err, {noOperators: true} if err or operators.length is 0

      # create all necessary artifacts
      async.parallel {
        session: Session(accountId).create { role: 'Visitor', chatName: username }
        chat: Chat(accountId).create

      }, (err, {chat, session}) ->
        if err
          errData = {error: err, chatId: chat?.id, sessionId: session?.id}
          config.log.error 'Error creating session and chat in newChat', errData

        showToOperators = (next) ->
          notify = (op, next) ->
            Session(accountId).get(op.sessionId).unansweredChats.add chat.id, next

          async.map operators, notify, next

        tasks = [
          chat.visitor.mset visitorMeta
          showToOperators
          ChatSession(accountId).add session.id, chat.id, { isWatching: 'false', type: 'member' }
        ]
        tasks.push chat.website.set websiteId if websiteId
        tasks.push chat.department.set department if department

        async.parallel tasks, (err) ->
          if err
            errData = {
              error: err, chatId: chat.id, visitor: visitorMeta, sessionId: session.id,
              websiteId: websiteId, department: department
            }
            config.log.error 'Error in newChat', errData

          # set cookie and create pulsar channel
          res.cookie 'session', session.id
          createChannel chat.id

          # respond to visitor browser
          res.reply err, chatId: chat.id

          # query for ACP data and store it in redis
          populateVisitorAcpData accountId, chat.id, userData
