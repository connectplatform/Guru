async = require 'async'
redgoose = require 'redgoose'
{OperatorChat, Chat} = redgoose.models

module.exports = (res) ->
  # get all my chats
  operatorId = unescape(res.cookie 'session')
  OperatorChat.getChatsByOperator operatorId, (err, operatorChats) ->
    res.send err, null if err

    # get the isWatching field from operatorChat
    getIsWatching = (operatorChat, cb) ->
      operatorChat.relationMeta.get 'isWatching', (err, isWatching) ->
        cb err, [operatorChat.chatId, isWatching]

    async.map operatorChats, getIsWatching, (err, arr) ->

      # get info for a specific chat
      doLookup = ([chat, isWatching], cb) ->
        Chat.get(chat).dump (err, data) ->
          console.log "Error getting chat from cache: data:#{data}, error:#{err}" if err
          message.timestamp = new Date(parseInt(message.timestamp)) for message in data.history
          data.isWatching = isWatching == "true" ? true : false
          cb err, data

      async.map arr, doLookup, res.send