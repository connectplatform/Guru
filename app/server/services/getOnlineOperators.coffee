stoic = require 'stoic'
{Session} = stoic.models
async = require 'async'

getChatName = (session, cb) ->
  session.chatName.get cb

module.exports = (res) ->

  Session.onlineOperators.all (err, sessions) ->
    console.log 'Error getting online operators: ', err if err?
    async.map sessions, getChatName, (err, operatorNames) ->
      res.reply err, operatorNames
