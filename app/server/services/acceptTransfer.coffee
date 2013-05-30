async = require 'async'
db = config.require 'load/mongo'
{ChatSession} = db.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({sessionId, accountId, chatId}, done) ->

    ChatSession.findOne {sessionId, chatId}, (err, chatSession) ->
      done err, null if err

      # We will need to remove this Operator from the Chat
      initiatorSessionId = chatSession?.initiator
      
      chatSession?.initiator = null
      chatSession?.relation  = 'Member'
      chatSession?.save (err) ->
        done err, null if err

        cond =
          sessionId: initiatorSessionId
          chatId: chatId
        ChatSession.findOne cond, (err, initiatorChatSession) ->
          done err, null if err

          initiatorChatSession?.remove (err) ->
            done err, {chatId}

