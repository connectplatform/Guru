
module.exports = (cb)->
  redisClient = require('redis').createClient()
  
  redisClient.on 'ready', ->
    redis = client: redisClient

    rand = require '../lib/rand'
    loadChats = (client)->
      create: (cb)->
        id = "chat:#{rand()}:history"
        client.sadd "chat:allChats", id, cb id

      add: (id, data, cb)->
        client.rpush id, JSON.stringify(data), cb

      get: (id, cb)->
        client.lrange id, 0, -1, (err, data)->
          cb err, undefined if err
          cb null, (JSON.parse item for item in data)

      getChatIds: (cb)->
        client.smembers "chat:allChats", cb

    redis.chats = loadChats redisClient

    cb redis