should = require 'should'

boiler 'Service - Find Model', ->

  it 'should let you get all instances of a model', (done) ->
    @getAuthed =>

      #do test
      @client.findModel {queryObject: {}, modelName: 'User'}, (err, users) ->
        should.not.exist err
        for user in users
          user.firstName.should.exist
          user.lastName.should.exist
          user.email.should.exist
          user.role.should.exist
          user.websites.should.exist
          user.specialties.should.exist
          user.id.should.exist
          should.not.exist user.password

        done()

  it 'should let you find a user by their id', (done) ->
    @getAuthed =>

      @client.findModel {queryObject: {_id: @ownerUser.id}, modelName: 'User'}, (err, [owner]) ->
        owner.firstName.should.eql 'Owner'
        owner.lastName.should.eql 'Man'
        owner.role.should.eql 'Owner'
        should.exist owner.websites
        owner.specialties.should.eql []

        done()
