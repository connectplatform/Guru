module.exports =
  required: ['sessionSecret', 'sessionId']
  service: ({sessionId}, done) ->
    ChatSession.find {sessionId}, {chatId: 1}, (err, chatSessions) ->
      return done err if err

      chatIds = (cs.chatId for cs in chatSessions)
      Chat.find {_id: {'$in': chatIds}}, (err, chats) ->
        done err, {data: chats}
