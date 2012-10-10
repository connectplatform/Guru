{tandoor} = config.require 'load/util'
async = require 'async'

stoic = require 'stoic'
{Session} = stoic.models

module.exports = tandoor (chatId, done) ->

  Session.allSessions.all (err, sessions) ->
    remove = (session, next) ->
      Session.get(session.id).unansweredChats.srem chatId, next

    async.forEach sessions, remove, done
