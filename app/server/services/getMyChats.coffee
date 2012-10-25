async = require 'async'
stoic = require 'stoic'
{Session, ChatSession, Chat} = stoic.models

module.exports = ({sessionId}, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->

    ChatSession(accountId).getBySession sessionId, (err, chatSessions) ->
      done err, null if err

      # get the isWatching field from chatSession
      getIsWatching = (chatSession, cb) ->
        chatSession.relationMeta.get 'isWatching', (err, isWatching) ->
          cb err, [chatSession.chatId, isWatching]

      async.map chatSessions, getIsWatching, (err, arr) ->
        if err
          config.log.error 'Error mapping chat sessions in getMyChats', {error: err, chatSessions: chatSessions}
          return done err, null

        # get info for a specific chat
        doLookup = ([chat, isWatching], cb) ->
          Chat(accountId).get(chat).dump (err, data) ->
            config.log.error 'Error getting chat in getMyChats', {error: err, chatId: chat} if err
            message.timestamp = new Date(parseInt(message.timestamp)) for message in data.history
            data.isWatching = isWatching == "true" ? true : false
            cb err, data

        async.map arr, doLookup, done
