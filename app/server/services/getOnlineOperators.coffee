# NOTE: this is not in use!

db = config.require 'load/mongo'
{Session} = db.models
async = require 'async'

getChatName = (session, done) ->
  session.chatName.get done

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->
    Session.find {accountId}, {username: true}, (err, sessions) ->
      if err
        config.log.error 'Error getting online operators', {error: err}
        return done err

      operatorNames = (s.username for s in sessions)

      done err, {operatorNames: operatorNames}
