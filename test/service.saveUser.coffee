require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Save User', ->

  it 'should create a user if no id is provided', (done) ->
    #Get authed
    @client.ready =>
      loginData =
        email: 'god@torchlightsoftware.com'
        password: 'foobar'
      @client.login loginData, =>

        #do test
        fields =
          firstName: "Gnu"
          lastName: "Yewser"
          role: "Operator"
          email: "yewser@torchlightsoftware.com"

        @client.saveUser fields, (err, user) =>
          user.firstName.should.eql fields.firstName
          user.lastName.should.eql fields.lastName
          user.email.should.eql fields.email

          #check results
          false.should.eql err?
          @client.findUser {_id: user.id}, (err, foundUsers) =>
            false.should.eql err?
            foundUsers[0].firstName.should.eql fields.firstName
            foundUsers[0].lastName.should.eql fields.lastName
            foundUsers[0].email.should.eql fields.email
            done()

  it "should edit a user if the user's id is provided", (done) ->
    #Get authed
    @client.ready =>
      loginData =
        email: 'god@torchlightsoftware.com'
        password: 'foobar'
      @client.login loginData, =>

        #change fields and resave
        @client.findUser {}, (err, foundUsers) =>
          target = foundUsers[1]
          target.firstName = "Seamus"
          @client.saveUser target, (err, user) =>
            false.should.eql err?

            user.firstName.should.eql target.firstName
            user.lastName.should.eql target.lastName
            user.email.should.eql target.email

            #check that save was successful
            @client.findUser {_id: user.id}, (err, foundUsers) =>
              false.should.eql err?
              foundUsers[0].should.eql target
              done()
