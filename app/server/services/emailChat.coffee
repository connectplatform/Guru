db = config.require 'load/mongo'
{Chat} = db.models

sendEmail = config.require 'services/email/sendEmail'
render = config.require 'services/templates/renderTemplate'

module.exports =
  required: ['chatId', 'email', 'accountId', 'sessionSecret', 'sessionId']
  service: ({chatId, email}, done) ->
    Chat.findById chatId, (err, chat) ->
      return done err if err
      return done (new Error 'Chat not found') unless chat?

      body = render 'chatHistory', chat
      sendingOptions =
        to: email
        subject: "Transcript of your chat on #{config.app.name}"
      sendEmail body, sendingOptions, done