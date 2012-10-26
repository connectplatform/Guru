should = require 'should'
db = require 'mongoose'

userFields =
  firstName: 'Gnu'
  lastName: 'Yewser'
  role: 'Operator'
  email: 'test@torchlightsoftware.com'

boiler 'Service - Save Model', ->

  describe 'creating a user', ->
    beforeEach (done) ->
      @getAuthed =>
        @client.saveModel {fields: userFields, modelName: 'User'}, (err, @user) =>
          should.not.exist err
          done()

    it 'should store fields', (done) ->
      @user.firstName.should.eql userFields.firstName
      @user.lastName.should.eql userFields.lastName
      @user.email.should.eql userFields.email

      #check results
      @client.findModel {queryObject: {_id: @user.id}, modelName: 'User'}, (err, foundUsers) =>
        should.not.exist err
        foundUsers[0].firstName.should.eql userFields.firstName
        foundUsers[0].lastName.should.eql userFields.lastName
        foundUsers[0].email.should.eql userFields.email
        done()

  it 'should edit an existing user', (done) ->
    @getAuthed =>

      #change fields and resave
      @client.findModel {queryObject: {}, modelName: 'User'}, (err, [target]) =>
        target.firstName = 'Seamus'
        @client.saveModel {fields: target, modelName: 'User'}, (err, user) =>
          should.not.exist err

          user.firstName.should.eql target.firstName
          user.lastName.should.eql target.lastName
          user.email.should.eql target.email

          #check that save was successful
          @client.findModel {queryObject: {_id: user.id}, modelName: 'User'}, (err, foundUsers) =>
            should.not.exist err
            foundUsers[0].should.eql target
            done()
