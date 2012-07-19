should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Find User', ->

  it 'should let you get all users', (done) ->
    @getAuthed =>

      #do test
      @client.findUser {}, (err, users) ->
        false.should.eql err?
        for user in users
          user.firstName.should.exist
          user.lastName.should.exist
          user.email.should.exist
          user.role.should.exist
          user.websites.should.exist
          user.departments.should.exist
          user.id.should.exist
          false.should.eql user.password?

        done()

  it 'should let you find a user by their id', (done) ->
    @getAuthed =>

      @client.findUser {email: 'god@torchlightsoftware.com'}, (err, [god]) ->
        god.firstName.should.eql 'God'
        god.lastName.should.eql ''
        god.role.should.eql 'Administrator'
        god.websites.should.eql []
        god.departments.should.eql []

        done()
