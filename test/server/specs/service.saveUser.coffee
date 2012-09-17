should = require 'should'

#do test
userFields =
  firstName: "Gnu"
  lastName: "Yewser"
  role: "Operator"
  email: "test@torchlightsoftware.com"

boiler 'Service - Save User', ->
  before ->
    @createUser = (next) =>
      @getAuthed =>
        @client.saveModel userFields, "User", next


  it 'should create a user if model is User and no id is provided', (done) ->
    @createUser (err, user) =>
      user.firstName.should.eql userFields.firstName
      user.lastName.should.eql userFields.lastName
      user.email.should.eql userFields.email

      #check results
      false.should.eql err?
      @client.findModel {_id: user.id}, "User", (err, foundUsers) =>
        false.should.eql err?
        foundUsers[0].firstName.should.eql userFields.firstName
        foundUsers[0].lastName.should.eql userFields.lastName
        foundUsers[0].email.should.eql userFields.email
        done()

  it 'should send an email when creating a user', (done) ->
    @createUser (err, user) =>
      done()

  it "should edit a user if model is User the user's id is provided", (done) ->
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
