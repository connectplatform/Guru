stoic = require 'stoic'
async = require 'async'
{queryArray} = config.require 'load/util'

{ChatSession, Session} = stoic.models

module.exports = ({accountId, chatId, queries}, done) ->
  ChatSession(accountId).getByChat chatId, (err, chatSessions) ->
    config.log.error 'Error getting chatSessions in queryChat', {error: err, chatId: chatId, accountId: accountId} if err

    mergeInMetadata = (chatSession, cb) ->
      chatSession.relationMeta.getall (err, meta) ->
        meta.relationType = delete meta.type
        chatSession.merge meta
        cb err

    async.forEach chatSessions, mergeInMetadata, (err) ->
      config.log.error 'Error attaching chatSession metadata to chatSessions', {error: err, accountId: accountId, chatId: chatId} if err
      mergeInSession = (chatSession, cb) ->
        Session(accountId).get(chatSession.sessionId).dump (err, sessionData) ->
          chatSession.merge sessionData
          cb err

      async.forEach chatSessions, mergeInSession, (err) ->
        config.log.error 'Error attaching chat data to chatSessions', {error: err, accountId: accountId, chatId: chatId} if err

        done err, queryArray chatSessions, queries
