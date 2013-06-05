async = require 'async'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'

module.exports =
  required: ['websiteUrl', 'websiteId', 'accountId']
  optional: ['specialtyName', 'specialtyId']
  service: (params, done) ->
    {websiteId, websiteUrl, specialtyId, username} = params
    username ||= 'anonymous'
    getWebsiteIdForDomain = config.service 'websites/getWebsiteIdForDomain'
    getAvailableOperators = config.service 'operator/getAvailableOperators'

    getAvailableOperators {websiteId, specialtyId}, (err, result) ->
      operators = result?.operators
      accountId = result?.accountId
      reason = result?.reason
      if err or reason
        errData = {error: err, websiteId: websiteId, specialtyId: specialtyId, reason: reason}
        config.log.warn 'Could not get availible operators for new chat.', errData
      if err or operators.length is 0
        return done err, {noOperators: true}
      async.parallel {
        session: (next) -> Session.create {accountId, username}, next
        chat: (next) -> Chat.create {accountId, status: 'Waiting', websiteId, websiteUrl, specialtyId, name: username}, next
      }, (err, {chat, session}) ->
        return done err if err
        # assert chat?
        showToOperators = (next) ->
          notify = (op, next) ->
            Session.findOne {userId: op.id}, (err, sess) ->
              sess.unansweredChats.push chat.id
              sess.save next
              
          async.map operators, notify, next
        tasks = [
          (next) ->
            data =
              sessionId: session.id
              chatId: chat.id
              relation: 'Member'
            ChatSession.create data, next
          (next) ->
            chat.websiteId = websiteId
            chat.websiteUrl = params.websiteUrl
            chat.specialtyId = specialtyId if specialtyId
            chat.save next
          showToOperators
        ]
        async.parallel tasks, (err) ->
          # respond to visitor browser
          chatData =
            chatId: chat.id
            sessionId: session.id
            sessionSecret: session.secret
          
          # query for ACP data and store it in redis
          populateVisitorAcpData accountId, chat.id, params

          done err, chatData