db = config.require 'load/mongo'
{Chat} = db.models

chatPriority = config.require 'services/chats/chatPriority'

module.exports =
  required: ['sessionSecret', 'sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    Chat.find {accountId, status: {'$ne': 'Vacant'}}, (err, chats) ->
      return done err, null if err

      chats = chats.sortBy(chatPriority)
      return done null, {chats}
