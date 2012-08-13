should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Find User', ->

  it 'should let you get all users', (done) ->
    @getAuthed =>

      #do test
      @client.findModel {}, "User", (err, users) ->
        false.should.eql err?
        for user in users
          user.firstName.should.exist
          user.lastName.should.exist
          user.email.should.exist
          user.role.should.exist
          user.websites.should.exist
          user.specialties.should.exist
          user.id.should.exist
          false.should.eql user.password?

        done()

  it 'should let you find a user by their id', (done) ->
    @getAuthed =>

      @client.findModel {email: 'admin@foo.com'}, "User", (err, [admin]) ->
        admin.firstName.should.eql 'Admin'
        admin.lastName.should.eql 'Guy'
        admin.role.should.eql 'Administrator'
        admin.websites.should.eql []
        admin.specialties.should.eql []

        done()
