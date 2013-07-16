db = config.require 'load/mongo'
{Chat} = db.models

module.exports =
  dependencies:
    services: ['email/sendEmail', 'templates/renderTemplate']
  required: ['chatId', 'email', 'accountId', 'sessionSecret', 'sessionId']
  service: ({chatId, email}, done, {services}) ->
    sendEmail = services['email/sendEmail']
    render = services['templates/renderTemplate']
    console.log {sendEmail, render}
    
    Chat.findById chatId, (err, chat) ->
      return done err if err
      return done (new Error 'Chat not found') unless chat?

      body = render {template: 'chatHistory', options: chat}

      sendingOptions =
        to: email
        subject: "Transcript of your chat on #{config.app.name}"
      sendEmail {body, vars: sendingOptions}, done