should = require 'should'
stoic = require 'stoic'

boiler 'Memory Leaks', ->
  describe 'Raw service', ->
    it 'should not leak like a sieve', (done) ->
      config.services['login'] {}, ->
        done()

  describe 'Wrapped service', ->
    it 'should not leak like a sieve', (done) ->
      config.require('services/login').service {email: 'foo@bar.com', password: 'yeah'}, ->
        done()
