should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Get Roles', ->

  it 'should return a list of roles', (done) ->
    @getAuthed =>
      @client.getRoles (err, roles) =>
        should.not.exist err
        roles.should.includeEql "Operator"
        done()
