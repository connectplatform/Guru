should = require 'should'
sendEmail = config.require 'services/email/sendEmail'

describe 'sendEmail', ->

  it 'should send an email', (done) ->
    options =
      name: 'Bob'
      to: 'brandon@torchlightsoftware.com'
      operatorId: 'asdf'
      subject: 'Yo man'

    sendEmail 'confirmation', options, (err, status) ->
      should.not.exist err
      should.exist status
      status.message.should.eql 'Sendmail exited with 0'
      done()
