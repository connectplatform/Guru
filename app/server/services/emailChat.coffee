stoic = require 'stoic'
{Session, Chat} = stoic.models

sendEmail = config.require 'services/email/sendEmail'
render = config.require 'services/templates/renderTemplate'

module.exports = (res, chatId, email) ->
  Session.accountLookup.get res.cookie('session'), (err, accountId) ->
    Chat(accountId).get(chatId).history.all (err, history) ->
      return res.reply err if err?

      body = render 'chatHistory', history: history

      sendingOptions =
        to: email
        subject: "Transcript of your chat on #{config.app.name}"

      sendEmail body, sendingOptions, res.reply
