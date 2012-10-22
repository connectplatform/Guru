stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (res) ->
  session = res.cookie 'session'
  return res.reply() unless session

  Session.accountLookup.get session, (err, accountId) ->
    ChatSession(accountId).getBySession session, (err, [chatSession]) ->
      return res.reply err, chatId: chatSession.chatId if chatSession?
      res.reply()
