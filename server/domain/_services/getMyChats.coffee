async = require 'async'
sendChatsFromIdList = require '../sendChatsFromIdList'
redgoose = require 'redgoose'
{OperatorChat, Chat} = redgoose.models

module.exports = (res) ->

  operatorId = unescape(res.cookie 'session')
  OperatorChat.getChatsByOperator operatorId, (err, rawData)->
    res.send err, null if err

    doLookup = (obj) ->
      (cb) ->
        Chat.get(obj.chat).dump (err, data)->
          console.log "Error getting chat from cache: data:#{data}, error:#{err}" if err
          message.timestamp = new Date(parseInt(message.timestamp)) for message in data.history
          data.isWatching = obj.isWatching == "true" ? true : false
          cb null, data

    functions = (doLookup {chat: key, isWatching:rawData[key]} for key of rawData)

    async.parallel functions, (err, result)->
      res.send err, result
