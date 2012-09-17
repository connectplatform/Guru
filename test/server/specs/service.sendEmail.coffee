should = require 'should'
sendEmail = config.require 'services/email/sendEmail'

describe 'sendEmail', ->

  it 'should send an email', (done) ->
    options =
      to: 'test@torchlightsoftware.com'
      name: 'test'
      subject: "Welcome to #{config.app.name}"
      service: config.app.name
      activationLink: 'http://localhost:4000/#/resetPassword?uid=50538cceed60269170000001&regkey=abcd'

    sendEmail 'registration', options, (err, status) ->
      should.not.exist err
      should.exist status
      status.message.should.eql 'Sendmail exited with 0'
      done()
