async = require 'async'

db = config.require 'load/mongo'
{Session} = db.models

# Internal utility service, so we don't use Law.
# Currently only called by acceptChat.
module.exports = ({accountId, chatId}, done) ->
  Session.find {accountId}, (err, sessions) ->
    return done err if err

    remove = (session, next) ->
      index = session.unansweredChats.indexOf(chatId, 1)

      session.unansweredChats.splice(index) unless index < 0
      session.save next

    async.map sessions, remove, done
