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
      if err
        config.log.error 'Error mapping chat sessions in getMyChats', {error: err, chatSessions: chatSessions}
        return res.reply err, null

      # get info for a specific chat
      doLookup = ([chat, isWatching], cb) ->
        Chat.get(chat).dump (err, data) ->
          config.log.error 'Error getting chat in getMyChats', {error: err, chatId: chat} if err
          message.timestamp = new Date(parseInt(message.timestamp)) for message in data.history
          data.isWatching = isWatching == "true" ? true : false
          cb err, data

      async.map arr, doLookup, res.reply
