stoic = require 'stoic'
{Session} = stoic.models
async = require 'async'

getChatName = (session, cb) ->
  session.chatName.get cb

module.exports = (res) ->
  Session.onlineOperators.all (err, sessions) ->
    config.log.error 'Error getting online operators', {error: err} if err
    async.map sessions, getChatName, (err, operatorNames) ->
      config.log.error 'Error getting online operator names', {error: err} if err
      res.reply err, operatorNames
