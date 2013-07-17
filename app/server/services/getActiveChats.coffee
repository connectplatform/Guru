db = config.require 'load/mongo'
{Chat} = db.models

module.exports =
  dependencies:
    services: ['chats/chatPriority']
  required: ['sessionSecret', 'sessionId', 'accountId']
  service: ({accountId}, done, {services}) ->
    chatPriority = services['chats/chatPriority']
    
    Chat.find {accountId, status: {'$ne': 'Vacant'}}, (err, chats) ->
      return done err if err

      chats = chats.sortBy(chatPriority)
      done null, {chats}
