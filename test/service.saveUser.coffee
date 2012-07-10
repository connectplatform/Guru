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
          @client.findUser {_id: userId}, (err, foundUser) =>
            false.should.eql err?
            foundUser.firstName.should.eql fields.firstName
            foundUser.lastName.should.eql fields.lastName
            foundUser.email.should.eql fields.email
            done()