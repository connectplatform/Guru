messageReceived = config.require 'services/chats/messageReceived'
pulsar = config.require 'load/pulsar'

module.exports = (chatId) ->
  channel = pulsar.channel chatId
  channel.on 'clientMessage', (contents) ->
    messageReceived chatId, contents.session, contents.message, ->
