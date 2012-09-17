nodemailer = require 'nodemailer'
getBody = config.require 'services/email/getBody'
{transport, options} = config.app.mail

module.exports = (template, vars, done) ->
  vars.merge
    from: options.from
    service: config.app.name

  sender = nodemailer.createTransport transport, options

  getBody template, vars, (err, body) ->
    if err?
      console.log "Error getting email template:", err
      return done err

    vars.html = body
    console.log "Sending '#{template}' email to #{vars.to}."
    sender.sendMail vars, done
