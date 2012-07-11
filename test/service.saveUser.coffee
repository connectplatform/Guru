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

        @client.saveUser fields, (err, userId) =>
          
          #check results
          false.should.eql err?
          @client.findUser {_id: userId}, (err, foundUsers) =>
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
          @client.saveUser target, (err, userId) =>
            false.should.eql err?

            #check that save was successful
            @client.findUser {_id: userId}, (err, foundUsers) =>
              false.should.eql err?
              foundUsers[0].should.eql target
              done()
