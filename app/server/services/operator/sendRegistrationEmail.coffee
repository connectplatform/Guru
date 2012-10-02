db = require 'mongoose'
{User} = db.models
sendEmail = config.require 'services/email/sendEmail'
rand = config.require 'services/rand'
getBody = config.require 'services/email/getBody'
{getActivationLink} = config.app.mail

module.exports = (user, next) ->
  # don't send twice
  if user.sentEmail
    return next()

  regkey = rand()

  options =
    to: user.email
    subject: "Welcome to #{config.app.name}"
    from: config.app.mail.options.from
    userName: user.firstName
    activationLink: getActivationLink user._id, regkey
    serviceName: config.app.name

  getBody 'registration', options, (err, body) ->
    if err?
      console.log "Error getting email template:", err
      return next err

    sendEmail body, options, ->
      user.registrationKey = regkey
      user.sentEmail = true
      next()
