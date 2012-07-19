pulsar = require '../../pulsar'
redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res) ->

  ChatSession.getBySession unescape(res.cookie 'session'), (err, [chatSession]) ->
    return res.send null, channel: chatSession.chatId if chatSession?
    res.send null, null