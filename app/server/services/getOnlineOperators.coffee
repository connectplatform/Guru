stoic = require 'stoic'
{Session} = stoic.models
async = require 'async'

getChatName = (session, done) ->
  session.chatName.get done

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->
    Session(accountId).onlineOperators.all (err, sessions) ->
      config.log.error 'Error getting online operators', {error: err} if err
      async.map sessions, getChatName, (err, operatorNames) ->
        config.log.error 'Error getting online operator names', {error: err} if err
        done err, operatorNames
