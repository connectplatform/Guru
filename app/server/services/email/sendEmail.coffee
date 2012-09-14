nodemailer = require 'nodemailer'
getBody = config.require 'services/email/getBody'
{transport, options} = config.app.mail

module.exports = (template, vars, done) ->
  vars.merge from: options.from

  sender = nodemailer.createTransport transport, options

  getBody template, vars, (err, body) ->
    return done err if err?
    vars.html = body
    sender.sendMail vars, done
