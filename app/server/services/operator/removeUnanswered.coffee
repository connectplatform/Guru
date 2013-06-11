{tandoor} = config.require 'load/util'
async = require 'async'

db = config.require 'load/mongo'
{Session} = db.models

# module.exports = tandoor (accountId, chatId, done) ->
module.exports = ({accountId, chatId}, done) ->
  Session.find {accountId}, (err, sessions) ->
    remove = (session, next) ->
      console.log 'session.unansweredChats', session.unansweredChats
      index = session.unansweredChats.indexOf(chatId, 1)

      session.unansweredChats.splice(index) unless index < 0
      session.save next

    async.map sessions, remove, done
