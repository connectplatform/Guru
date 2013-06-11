async = require 'async'

db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  optional: ['message']
  service: ({sessionId, accountId, chatId, message}, done) ->
    # get user's identity and operators present
    async.parallel {
        chat: (next) -> Chat.findById chatId, next
        chatSession: (next) -> ChatSession.findOne {sessionId, chatId}, next
        session: (next) -> Session.findById sessionId, next
      }, (err, {chat, chatSession, session}) ->
        return done err if err

        said =
          message: message
          username: session.username
          timestamp: Date.now()

        # Get and notify operators
        # TODO: Refactor into separate service
        ChatSession.find {chatId}, (err, chatSessions) ->
          sessionIds = (c.sessionId for c in chatSessions)
          condition =
            _id: '$in': sessionIds
            userId: '$ne': null
          Session.find condition, (err, operatorSessions) ->
            async.forEach operatorSessions, (opSession, next) ->
              opSession.unreadMessages += 1
              opSession.save next

            chat.history.push said
            chat.save done
