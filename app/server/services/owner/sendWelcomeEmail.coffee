sendEmail = config.require 'services/email/sendEmail'
renderTemplate = config.require 'services/templates/renderTemplate'

module.exports = (user, next) ->
  # don't send twice
  if user.sentEmail
    return next()

  renderOptions =
    serviceName: config.app.name
    url: config.app.url

  body = renderTemplate 'welcome', renderOptions

  sendingOptions =
    to: user.email
    subject: "Welcome to #{config.app.name}"

  sendEmail body, sendingOptions, ->
    user.sentEmail = true
    next()
