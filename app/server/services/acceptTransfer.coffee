async = require 'async'
db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'accountId', 'chatId']
  service: ({sessionId, accountId, chatId}, done) ->
    ChatSession.findOne {sessionId, chatId}, (err, chatSession) ->
      return done err, null if err
      return done (new Error 'chatSession not found') unless chatSession?

      # We will need to remove this Operator from the Chat
      initiatorSessionId = chatSession.initiator
      
      chatSession.initiator = null
      chatSession.relation  = 'Member'
      chatSession.save (err) ->
        return done err if err

        cond =
          sessionId: initiatorSessionId
          chatId: chatId
        ChatSession.findOne cond, (err, initiatorChatSession) ->
          return done err if err

          initiatorChatSession?.remove (err) ->
            done err, {chatId}

