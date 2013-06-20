{ChatSession} = config.require('load/mongo').models

module.exports =
  required: ['sessionSecret', 'sessionId']
  service: ({sessionId}, done) ->
    ChatSession.find {sessionId}, {_id: 1, chatId: 1}, (err, chatSessions) ->
      chatIds = []
      chatRelation = {}
      for cs in (chatSessions or [])
        chatIds.push cs.chatId
        chatRelation[cs._id] = cs.chatId

      done err, {chatIds, chatRelation}
