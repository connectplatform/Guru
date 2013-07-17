should = require 'should'

boiler 'Service - sendEmail', ->
  describe 'sendEmail', ->
  
    it 'should send an email', (done) ->
      sendEmail = config.services['email/sendEmail']
      should.exist sendEmail
      
      options =
        to: 'success@simulator.amazonses.com'
        name: 'test'
        subject: "Welcome to #{config.app.name}"
  
      body = "Hello, world!"
  
      sendEmail {body, options}, (err, status) ->
        should.not.exist err
        should.exist status
        status.message.should.match /MessageId/
        done()
