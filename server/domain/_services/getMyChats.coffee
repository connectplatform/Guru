module.exports = (res) ->
  redisFactory = require '../../redis'
  async = require 'async'
  redisFactory (redis)->
    redis.operators.chats unescape(res.cookie 'session'), (err, rawData)-> #TODO: this is the only line not identical to getActiveChats-- refactor
      {inspect} = require 'util'
      data = rawData.filter (element)->
        element != 'true' #this is a bogus item added by the redis query TODO: should I worry about this?
        
      res.send err, null if err
      chats = []

      pushChat = (item, cb)->
        redis.chats.get item, (err, data)->
          console.log "Error getting chat from cache: id:#{chat}, error:#{err}" if err
          message.timestamp = new Date(parseInt(message.timestamp)) for message in data.history
          chats.push data
          cb()

      async.forEach data, pushChat, ->
        res.send null, chats