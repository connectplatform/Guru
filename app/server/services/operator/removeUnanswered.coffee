{tandoor} = config.require 'load/util'
async = require 'async'

stoic = require 'stoic'
{Session} = stoic.models

module.exports = tandoor (accountId, chatId, done) ->

  Session(accountId).allSessions.all (err, sessions) ->
    remove = (session, next) ->
      Session(accountId).get(session.id).unansweredChats.srem chatId, next

    async.map sessions, remove, () -> done()
