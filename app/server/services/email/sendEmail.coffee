nodemailer = require 'nodemailer'
{options, transport} = config.app.mail

module.exports = (body, vars, done) ->
  sender = nodemailer.createTransport transport, options

  vars.from ||= config.app.mail.options.from
  vars.html ||= body

  console.log "Sending email to #{vars.to}."
  #console.log "Body:", vars.html
  sender.sendMail vars, (err, args...) ->

    # vein chokes on an Error object
    err = err.toString() if err
    done err, args...
