nodemailer = require 'nodemailer'
{options, transport} = config.app.mail

module.exports = (body, vars, done) ->

  sender = nodemailer.createTransport transport, options

  vars.html = body
  console.log "Sending email to #{vars.to}."
  sender.sendMail vars, done
