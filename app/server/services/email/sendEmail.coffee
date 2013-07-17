nodemailer = require 'nodemailer'
{mail} = config.app
logger = config.require 'lib/logger'

module.exports = ({body, options}, done) ->
  done ||= ->
  sender = nodemailer.createTransport mail.transport, mail.options
  options.from ||= mail.options.from
  options.html ||= body
  config.log.info "Sending email to #{options.to}."
  sender.sendMail options, (err, response) ->
    if err
      config.log.warn "Failed to send email: #{err}", options if err
      return done err if err
    
    data =
      message: response?.message
      messageId: response?.messageId
      status: response?.status

    done err, data
