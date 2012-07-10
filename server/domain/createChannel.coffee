{tandoor} = require '../../lib/util'
redgoose = require 'redgoose'

module.exports = tandoor (serviceName, pulsar) ->
  channel = pulsar.channel serviceName
  channel.on 'clientMessage', (contents) ->
    {Session, Chat} = redgoose.models

    Session.get(contents.session).chatName.get (err, username) ->

      console.log "Error getting chat name from cache: #{err}" if err
      data =
        message: contents.message
        username: username
        timestamp: Date.now()

      Chat.get(serviceName).history.add data, (err) ->
        console.log "error caching message: #{err}" if err

      channel.emit 'serverMessage', data
