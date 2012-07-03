module.exports = (res) ->
  redis = require '../../redis'
  async = require 'async'
  redis.chats.getChatIds (err, rawData)->
    data = rawData.filter (element)->
      element != 'true' #this is a bogus item added by the redis query TODO: should I worry about this?
      
    res.send err, null if err
    chats = []

    pushChat = (item, cb)->
      redis.chats.get item, (err, data)->
        console.log "Error getting chat from cache: id:#{chat}, error:#{err}" if err
        chats.push data
        cb()

    async.forEach data, pushChat, ->
      res.send null, chats