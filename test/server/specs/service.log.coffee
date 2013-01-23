should = require 'should'

boiler 'Service - Log', ->
  it 'should take a set of optional fields and log data', (done) ->
    @getAuthed =>
      @client.log {message: 'Something Happened', context: {
        service: 'Some service'
        error: 'An error'
        ids:
          sessionId: @client.cookie 'session'
          chatId: 'Invalid LOL'
        }
      }, (err) =>
        @client.disconnect()
        should.not.exist err
        done()

  it 'should work when no extra data is given', (done) ->
    @getAuthed =>
      @client.log {message: 'vague happening', context: {}}, (err) =>
        @client.disconnect()
        should.not.exist err
        done()
