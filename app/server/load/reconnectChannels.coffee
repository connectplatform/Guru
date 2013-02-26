async = require 'async'
{Chat, Session} = require('stoic').models
{Account} = require('mongoose').models

module.exports = ->
  reconnectForAccount = (accountId) ->
    async.parallel {
      chats: Chat(accountId).allChats.all
      sessions: Session(accountId).allSessions.all
    }, (err, {chats, sessions}) ->
      config.log.error "Error getting redis data when trying to reconnect pulsar channels.", {error: err} if err

      pulsar = config.require 'load/pulsar'
      createChannel = config.require 'services/chats/createChannel'

      if chats
        for chat in chats
          createChannel chat

      if sessions
        for session in sessions
          pulsar.channel "notify:session:#{session.id}"

  Account.find {}, (err, accounts) ->
    reconnectForAccount account.id for account in accounts
