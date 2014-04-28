should = require 'should'
sendEmail = config.require 'services/email/sendEmail'

describe 'sendEmail', ->

  # Purpose of this test?
  it 'should send an email', (done) ->
    options =
      to: 'success@simulator.amazonses.com'
      name: 'test'
      subject: "Welcome to #{config.app.name}"

    body = "Hello, world!"

    sendEmail body, options, (err, status) ->
      should.not.exist err
      should.exist status
      status.message.should.match /Message-Id/
      done()
