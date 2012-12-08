should = require 'should'

boiler 'Service - Log', ->
  it 'should take a set of optional fields and log data', (done) ->
    @getAuthed =>
      @client.getHeaderFooter {}, (err, result) ->
        should.not.exist err
        should.exist result?.header, 'expected header'
        should.exist result?.footer, 'expected footer'
        done()
