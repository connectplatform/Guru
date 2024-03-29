sendEmail = config.require 'services/email/sendEmail'
{random} = config.require 'load/util'
{getActivationLink} = config.app.mail

renderTemplate = config.require 'services/templates/renderTemplate'

module.exports = (user, next) ->
  # don't send twice
  if user.sentEmail
    return next()

  regkey = random()

  renderOptions =
    userName: user.firstName
    activationLink: getActivationLink user._id, regkey
    serviceName: config.app.name

  body = renderTemplate 'registration', renderOptions

  sendingOptions =
    to: user.email
    subject: "Welcome to #{config.app.name}"

  sendEmail body, sendingOptions, -> # fire and forget

  user.registrationKey = regkey
  user.sentEmail = true

  next()
