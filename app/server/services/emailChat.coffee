stoic = require 'stoic'
{Chat} = stoic.models

render = config.require 'services/templates/renderTemplate'

module.exports = (res, chatId, email) ->
  Chat.get(chatId).history.all (err, history) ->
    return res.reply err if err?

    body = render 'chatHistory', history: history

    sendingOptions =
      to: email
      subject: "Transcript of your chat on #{config.app.name}"

    sendEmail body, sendingOptions, (err, sendmailStatus) ->
      user.registrationKey = regkey
      user.sentEmail = true
      res.reply err, sendmailStatus
