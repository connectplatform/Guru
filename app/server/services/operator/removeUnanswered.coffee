{tandoor} = config.require 'load/util'
async = require 'async'

db = config.require 'load/mongo'
{Session} = db.models

# module.exports = tandoor (accountId, chatId, done) ->
module.exports = ({accountId, chatId}, done) ->
  Session.find {accountId}, (err, sessions) ->
    remove = (session, next) ->
      session.unansweredChats.splice(session.unansweredChats.indexOf(chatId, 1))
      session.save next
    async.map sessions, remove, done
    
  # Session(accountId).allSessions.all (err, sessions) ->
  #   remove = (session, next) ->
  #     Session(accountId).get(session.id).unansweredChats.srem chatId, next

  #   async.map sessions, remove, done
