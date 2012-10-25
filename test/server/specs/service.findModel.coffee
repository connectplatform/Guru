should = require 'should'

boiler 'Service - Find Model', ->

  it 'should let you get all instances of a model', (done) ->
    @getAuthed =>

      #do test
      @client.findModel {queryObject: {}, modelName: 'User'}, (err, users) ->
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

      @client.findModel {queryObject: {email: 'admin@foo.com'}, modelName: 'User'}, (err, [admin]) ->
        admin.firstName.should.eql 'Admin'
        admin.lastName.should.eql 'Guy'
        admin.role.should.eql 'Administrator'
        admin.websites.should.eql []
        admin.specialties.should.eql []

        done()
