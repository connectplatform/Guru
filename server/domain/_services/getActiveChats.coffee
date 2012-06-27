module.exports = (res) ->
  redisFactory = require '../../redis'
  async = require 'async'
  redisFactory (redis)->
    redis.chats.getChatIds (err, rawData)->
      data = rawData.filter (element)->
        element != 'true' #this is a bogus item added by the redis query
        
      {inspect} = require 'util'
      console.log "found chats: #{inspect data}"
      res.send err, null if err
      chats = []

      pushChat = (item, cb)->
        redis.chats.get item, (err, data)->
          console.log "Error getting chat from cache: id:#{chat}, error:#{err}" if err
          chats.push data
          cb()

      async.forEach data, pushChat, ->
        res.send null, chats