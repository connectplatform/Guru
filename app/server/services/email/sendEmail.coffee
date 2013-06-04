nodemailer = require 'nodemailer'
{options, transport} = config.app.mail
logger = config.require 'lib/logger'

module.exports = (body, vars, done) ->
  done ||= ->
  sender = nodemailer.createTransport transport, options
  vars.from ||= config.app.mail.options.from
  vars.html ||= body
  config.log.info "Sending email to #{vars.to}."
  sender.sendMail vars, (err, response) ->
    if err
      config.log.warn "Failed to send email: #{err}", vars if err
      done err if err
    
    data =
      message: response?.message
      messageId: response?.messageId
      status: response?.status

    done err, data
