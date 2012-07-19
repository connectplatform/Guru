pulsar = require '../../pulsar'
redgoose = require 'redgoose'
{SessionChat} = redgoose.models

module.exports = (res) ->

  SessionChat.getBySession unescape(res.cookie 'session'), (err, [chatSession]) ->
    return res.send null, channel: chatSession.chatId if chatSession?
    res.send null, null