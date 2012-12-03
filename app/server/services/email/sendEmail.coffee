nodemailer = require 'nodemailer'
{options, transport} = config.app.mail

module.exports = (body, vars, done) ->
  sender = nodemailer.createTransport transport, options

  vars.from ||= config.app.mail.options.from
  vars.html ||= body

  config.log.info "Sending email to #{vars.to}."
  sender.sendMail vars, (err, args...) ->

    # vein chokes on an Error object
    err = err.toString() if err
    config.log.warn "Failed to send email: #{err}", vars if err
    done err, args...
