db = config.require 'load/mongo'
{Chat, ChatSession} = db.models

module.exports =
  required: ['accountId', 'sessionSecret', 'sessionId']
  service: ({sessionId}, done) ->
    ChatSession.find {sessionId}, (err, chatSessions) ->
      return done err if err

      # If the operator has no ChatSessions, we are done.
      return done null, {chats: []} if chatSessions.length == 0

      # Collect the chatIds of Chats the operator is linked to.
      chatIds = (cs.chatId for cs in chatSessions)

      Chat.find {_id: '$in': chatIds}, (err, chats) ->
        return done err if err

        done null, {chats: chats}
