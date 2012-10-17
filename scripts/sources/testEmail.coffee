sendEmail = config.require 'services/email/sendEmail'

module.exports = (to) ->
  to ||= 'test@torchlightsoftware.com'

  options =
    to: to
    name: 'test'
    subject: "Welcome to #{config.app.name}"
    service: config.app.name
    activationLink: 'http://localhost:4000/#/resetPassword?uid=50538cceed60269170000001&regkey=abcd'

  sendEmail 'registration', options, (err, status) ->
    console.log 'err:', err if err
    console.log 'status:', status
    process.exit()
