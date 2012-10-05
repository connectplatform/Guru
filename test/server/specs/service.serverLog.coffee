should = require 'should'

boiler 'Service - Server Log', ->
  it 'should take a set of optional fields an log data', (done) ->
    @getAuthed =>
      @client.serverLog {
        message: 'Something Happened'
        service: 'Some service'
        error: 'An error'
        ids:
          sessionId: @client.cookie 'session'
          chatId: 'Invalid LOL'
      }, (err, ack) =>
        @client.disconnect()
        should.not.exist err
        ack.should.eql 'Success'
        done()

  it 'should work when no arguments are specified', (done) ->
    @getAuthed =>
      @client.serverLog {}, (err, ack) =>
        @client.disconnect()
        should.not.exist err
        ack.should.eql 'Success'
        done()
