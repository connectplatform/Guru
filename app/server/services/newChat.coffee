async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'

module.exports =
  required: ['websiteUrl', 'websiteId', 'accountId']
  optional: ['specialtyName', 'specialtyId']
  service: (params, done) ->
    {websiteId, specialtyId, username} = params
    username ||= 'anonymous'

    {Chat, Session, ChatSession} = stoic.models

    getWebsiteIdForDomain = config.service 'websites/getWebsiteIdForDomain'
    getAvailableOperators = config.service 'operator/getAvailableOperators'

    visitorMeta =
      username: username
      referrerData: params || null

    getAvailableOperators {websiteId: websiteId, specialtyId: specialtyId}, (err, result) ->
      operators = result?.operators
      accountId = result?.accountId
      reason = result?.reason
      if err or reason
        errData = {error: err, websiteId: websiteId, specialtyId: specialtyId, reason: reason}
        config.log.warn 'Could not get availible operators for new chat.', errData

      return done err, {noOperators: true} if err or operators.length is 0

      # create all necessary artifacts
      async.parallel {
        session: Session(accountId).create { role: 'Visitor', chatName: username }
        chat: Chat(accountId).create

      }, (err, {chat, session}) ->
        return done err if err

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
        tasks.push chat.specialtyId.set specialtyId if specialtyId

        async.parallel tasks, (err) ->

          # create pulsar channel
          createChannel chat.id

          # respond to visitor browser
          done err, {chatId: chat.id, sessionId: session.id}

          # query for ACP data and store it in redis
          populateVisitorAcpData accountId, chat.id, params
