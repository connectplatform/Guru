async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'

module.exports = (params, done) ->
  {Chat, Session, ChatSession} = stoic.models

  getWebsiteIdForDomain = config.service 'websites/getWebsiteIdForDomain'
  getAvailableOperators = config.service 'operator/getAvailableOperators'

  return done "Field required: websiteUrl" unless params?.websiteUrl

  getWebsiteIdForDomain {domain: params.websiteUrl}, (err, websiteId) ->
    return done "Could not find website: #{params.websiteUrl}" if err or not websiteId

    department = params.department
    username = params.username or 'anonymous'
    visitorMeta =
      username: username
      referrerData: params || null

    getAvailableOperators {websiteId: websiteId, specialtyId: department}, (err, result) ->
      operators = result?.operators
      accountId = result?.accountId
      reason = result?.reason
      if err or reason
        errData = {error: err, websiteId: websiteId, department: department, reason: reason}
        config.log.warn 'Could not get availible operators for new chat.', errData

      return done err, {noOperators: true} if err or operators.length is 0

      # create all necessary artifacts
      async.parallel {
        session: Session(accountId).create { role: 'Visitor', chatName: username }
        chat: Chat(accountId).create

      }, (err, {chat, session}) ->
        if err
          errData = {error: err, chatId: chat?.id, sessionId: session?.id}
          config.log.error 'Error creating session and chat for new chat.', errData

        showToOperators = (next) ->
          notify = (op, next) ->
            Session(accountId).get(op.sessionId).unansweredChats.add chat.id, next

          async.map operators, notify, next

        tasks = [
          chat.visitor.mset visitorMeta
          showToOperators
          ChatSession(accountId).add session.id, chat.id, { isWatching: 'false', type: 'member' }
        ]
        tasks.push chat.websiteId.set websiteId
        tasks.push chat.websiteUrl.set params.websiteUrl
        tasks.push chat.department.set department if department

        async.parallel tasks, (err) ->
          if err
            errData = {
              error: err, chatId: chat.id, visitor: visitorMeta, sessionId: session.id,
              websiteId: websiteId, department: department
            }
            config.log.error 'Error creating new chat.', errData

          # create pulsar channel
          createChannel chat.id

          # respond to visitor browser
          done err, {chatId: chat.id}, {setCookie: sessionId: session.id}

          # query for ACP data and store it in redis
          populateVisitorAcpData accountId, chat.id, params
