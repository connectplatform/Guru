stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = (res) ->
  session = res.cookie 'session'
  return res.reply() unless session

  ChatSession.getBySession session, (err, [chatSession]) ->
    return res.reply err, chatId: chatSession.chatId if chatSession?
    res.reply()
