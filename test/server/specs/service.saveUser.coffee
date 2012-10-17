should = require 'should'
db = require 'mongoose'

#do test
userFields =
  firstName: "Gnu"
  lastName: "Yewser"
  role: "Operator"
  email: "test@torchlightsoftware.com"

boiler 'Service - Save User', ->

  describe 'creating a user', ->
    beforeEach (done) ->
      @getAuthed =>
        @client.saveModel userFields, "User", (err, @user) =>
          done err

    it 'should store fields', (done) ->
      @user.firstName.should.eql userFields.firstName
      @user.lastName.should.eql userFields.lastName
      @user.email.should.eql userFields.email

      #check results
      false.should.eql err?
      @client.findModel {_id: @user.id}, "User", (err, foundUsers) =>
        false.should.eql err?
        foundUsers[0].firstName.should.eql userFields.firstName
        foundUsers[0].lastName.should.eql userFields.lastName
        foundUsers[0].email.should.eql userFields.email
        done()

  it "should edit an existing user", (done) ->
    @getAuthed =>

      #change fields and resave
      @client.findModel {}, "User", (err, [target]) =>
        target.firstName = "Seamus"
        @client.saveModel target, "User", (err, user) =>
          false.should.eql err?

          user.firstName.should.eql target.firstName
          user.lastName.should.eql target.lastName
          user.email.should.eql target.email

          #check that save was successful
          @client.findModel {_id: user.id}, "User", (err, foundUsers) =>
            false.should.eql err?
            foundUsers[0].should.eql target
            done()
