pulsar = require '../../pulsar'
redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res) ->
  return res.reply null, null unless res.cookie 'session'

  ChatSession.getBySession res.cookie('session'), (err, [chatSession]) ->
    return res.reply null, channel: chatSession.chatId if chatSession?
    res.reply null, null
