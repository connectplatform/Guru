db = require 'mongoose'
{User} = db.models
sendEmail = config.require 'services/email/sendEmail'
rand = config.require 'services/rand'

module.exports = (user, next) ->
  # don't send twice
  if user.sentEmail
    return next()

  options =
    name: user.firstName
    to: user.email
    regkey: rand()

  sendEmail 'registration', options, ->
    user.registrationKey = options.regkey
    user.sentEmail = true
    next()
