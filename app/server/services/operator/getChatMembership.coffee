{ChatSession} = config.require('load/mongo').models

# This just gets all related chats for now.  It could be extended to include a map of {id: relation}.
module.exports =
  required: ['sessionSecret', 'sessionId']
  service: ({sessionId}, done) ->
    ChatSession.find {sessionId}, {chatId: 1}, (err, chatSessions) ->
      chatIds = (chatSessions or []).map (cs) -> cs.chatId
      done err, {chatIds}
