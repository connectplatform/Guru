pulsar = require '../pulsar'
redgoose = require 'redgoose'

module.exports = (serviceName) ->

  # create a channel
  channel = pulsar.channel serviceName

  # when a message is received, add it to the history
  channel.on 'clientMessage', (contents) ->
    {Session, Chat} = redgoose.models

    Session.get(contents.session).chatName.get (err, username) ->

      console.log "Error getting chat name from cache: #{err}" if err
      data =
        message: contents.message
        username: username
        timestamp: Date.now()

      Chat.get(serviceName).history.rpush data, (err) ->
        console.log "error caching message: #{err}" if err

      channel.emit 'serverMessage', data
