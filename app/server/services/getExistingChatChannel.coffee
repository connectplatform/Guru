stoic = require 'stoic'
{ChatSession} = stoic.models

pulsar = config.require 'load/pulsar'

module.exports = (res) ->
  return res.reply null, null unless res.cookie 'session'

  ChatSession.getBySession res.cookie('session'), (err, [chatSession]) ->
    return res.reply null, channel: chatSession.chatId if chatSession?
    res.reply null, null