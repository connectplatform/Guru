should = require 'should'
db = require 'mongoose'

userFields =
  firstName: 'Gnu'
  lastName: 'Yewser'
  role: 'Operator'
  email: 'test@torchlightsoftware.com'
  specialties: ['Sales']

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
      @client.findModel {queryObject: {_id: @user.id}, modelName: 'User'}, (err, {data}) =>
        foundUsers = data
        should.not.exist err
        foundUsers[0].firstName.should.eql userFields.firstName
        foundUsers[0].lastName.should.eql userFields.lastName
        foundUsers[0].email.should.eql userFields.email
        should.exist foundUsers[0].specialties
        foundUsers[0].specialties.length.should.eql 1, 'expected one specialty'

        done()

  describe 'creating a website', ->
    beforeEach (done) ->
      website =
        url: 'five.com'
        contactEmail: 'six@five.com'

      @getAuthed =>
        @client.saveModel {fields: website, modelName: 'Website'}, (err, @website) =>
          should.not.exist err
          done()

    it 'should store fields', (done) ->
      should.exist @website.requiredFields
      @website.requiredFields.length.should.eql 1, 'expected a required field on website'
      done()

  it 'should edit an existing user', (done) ->
    @getAuthed =>

      #change fields and resave
      @client.findModel {queryObject: {}, modelName: 'User'}, (err, {data}) =>
        [target] = data
        target.firstName = 'Seamus'
        @client.saveModel {fields: target, modelName: 'User'}, (err, user) =>
          should.not.exist err

          user.firstName.should.eql target.firstName
          user.lastName.should.eql target.lastName
          user.email.should.eql target.email

          #check that save was successful
          @client.findModel {queryObject: {_id: user.id}, modelName: 'User'}, (err, {data}) =>
            foundUsers = data
            should.not.exist err
            foundUsers[0].firstName.should.eql target.firstName
            foundUsers[0].lastName.should.eql target.lastName
            foundUsers[0].email.should.eql target.email
            done()
