# stoic = require 'stoic'
# {Chat} = stoic.models

sendEmail = config.require 'services/email/sendEmail'
render = config.require 'services/templates/renderTemplate'

module.exports =
  required: ['chatId', 'email', 'accountId', 'sessionId']
  service: ({chatId, email, accountId, sessionId}, done) ->
    Chat(accountId).get(chatId).dump (err, chatData) ->
      return done err if err

      body = render 'chatHistory', chatData

      sendingOptions =
        to: email
        subject: "Transcript of your chat on #{config.app.name}"

      sendEmail body, sendingOptions, done
