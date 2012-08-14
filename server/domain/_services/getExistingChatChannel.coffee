pulsar = require '../../pulsar'
redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res) ->
  return res.send null, null unless res.cookie 'session'

  ChatSession.getBySession res.cookie('session'), (err, [chatSession]) ->
    return res.send null, channel: chatSession.chatId if chatSession?
    res.send null, null
