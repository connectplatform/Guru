should = require 'should'

boiler 'Service - Save Account', ->

  describe 'with valid info', ->
    before ->
      @params =
        email: 'bob@example.com'

    it 'should create an account', (done) ->
      @client = @getClient()
      @client.ready =>
        @client.createAccount @params, (err, status) =>
          should.not.exist err
          should.exist status
          should.exist status.id
          done()
