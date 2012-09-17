db = require 'mongoose'
{User} = db.models
sendEmail = config.require 'services/email/sendEmail'
rand = config.require 'services/rand'
{getActivationLink} = config.app.mail

module.exports = (user, next) ->
  # don't send twice
  if user.sentEmail
    return next()

  regkey = rand()

  options =
    name: user.firstName
    to: user.email
    subject: "Welcome to #{config.app.name}"
    activationLink: getActivationLink user._id, regkey

  sendEmail 'registration', options, ->
    user.registrationKey = regkey
    user.sentEmail = true
    next()
