nodemailer = require 'nodemailer'
getBody = config.require 'services/email/getBody'
{from, transport} = config.app.mailOptions

module.exports = (template, options, done) ->

  sender = nodemailer.createTransport transport, {
    args: ["-f #{from}"]
  }

  getBody template, options, (err, body) ->
    options.html = body
    sender.sendMail options, done
