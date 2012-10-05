db = require 'mongoose'
{User} = db.models
sendEmail = config.require 'services/email/sendEmail'
rand = config.require 'services/rand'
{getActivationLink} = config.app.mail

renderTemplate = config.require 'services/templates/renderTemplate'

module.exports = (user, next) ->
  # don't send twice
  if user.sentEmail
    return next()

  regkey = rand()

  renderOptions =
    userName: user.firstName
    activationLink: getActivationLink user._id, regkey
    serviceName: config.app.name

  body = renderTemplate 'registration', renderOptions

  sendingOptions =
    to: user.email
    subject: "Welcome to #{config.app.name}"

  sendEmail body, sendingOptions, ->
    user.registrationKey = regkey
    user.sentEmail = true
    next()
