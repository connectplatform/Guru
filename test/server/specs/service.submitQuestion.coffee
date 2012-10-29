should = require 'should'

boiler 'Service - Submit Question', ->

  it 'should send an email', (done) ->
    @client = @getClient()
    @client.ready =>

      email =
        email: 'jimbo@example.com'
        subject: 'test'
        body: 'test email'

      params =
        oid: 'asdf'
        cid: '123'

      @client.submitQuestion {emailData: email, customerData: params, websiteUrl: 'foo.com'}, (err, status) ->
        should.not.exist err
        should.exist status
        status.message.should.match /MessageId/
        done()
