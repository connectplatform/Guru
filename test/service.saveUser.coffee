should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Save Model', ->

  it 'should create a user if model is User and no id is provided', (done) ->
    @getAuthed =>

      #do test
      fields =
        firstName: "Gnu"
        lastName: "Yewser"
        role: "Operator"
        email: "yewser@foo.com"

      @client.saveModel fields, "User", (err, user) =>
        user.firstName.should.eql fields.firstName
        user.lastName.should.eql fields.lastName
        user.email.should.eql fields.email

        #check results
        false.should.eql err?
        @client.findModel {_id: user.id}, "User", (err, foundUsers) =>
          false.should.eql err?
          foundUsers[0].firstName.should.eql fields.firstName
          foundUsers[0].lastName.should.eql fields.lastName
          foundUsers[0].email.should.eql fields.email
          done()

  it "should edit a user if model is User the user's id is provided", (done) ->
    @getAuthed =>

      #change fields and resave
      @client.findModel {}, "User", (err, foundUsers) =>
        target = foundUsers[1]
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
