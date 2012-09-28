async = require 'async'
stoic = require 'stoic'
{ChatSession, Chat} = stoic.models

module.exports = (res) ->
  # get all my chats
  operatorId = unescape(res.cookie 'session')
  ChatSession.getBySession operatorId, (err, chatSessions) ->
    res.reply err, null if err

    # get the isWatching field from chatSession
    getIsWatching = (chatSession, cb) ->
      chatSession.relationMeta.get 'isWatching', (err, isWatching) ->
        cb err, [chatSession.chatId, isWatching]

    async.map chatSessions, getIsWatching, (err, arr) ->

      # get info for a specific chat
      doLookup = ([chat, isWatching], cb) ->
        Chat.get(chat).dump (err, data) ->
          console.log "Error getting chat from cache: data:#{data}, error:#{err}" if err
          message.timestamp = new Date(parseInt(message.timestamp)) for message in data.history
          data.isWatching = isWatching == "true" ? true : false
          cb err, data

      async.map arr, doLookup, res.reply
