require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Find User', ->

  it 'should let you get all users', (done) ->
    #Get authed
    @client.ready =>
      loginData =
        email: 'god@torchlightsoftware.com'
        password: 'foobar'
      @client.login loginData, =>

        #do test
        @client.findUser {}, (err, users) ->
          false.should.eql err?

          users[0].firstName.should.exist
          users[0].lastName.should.exist
          users[0].email.should.exist
          users[0].role.should.exist
          users[0].websites.should.exist
          users[0].departments.should.exist
          users[0].id.should.exist
          false.should.eql users[0].password?

          users[1].firstName.should.exist
          users[1].lastName.should.exist
          users[1].email.should.exist
          users[1].role.should.exist
          users[1].websites.should.exist
          users[1].departments.should.exist
          users[1].id.should.exist
          false.should.eql users[1].password?

          done()

  it 'should let you find a user by their id', (done) ->
    #Get authed
    @client.ready =>
      loginData =
        email: 'god@torchlightsoftware.com'
        password: 'foobar'
      @client.login loginData, =>

        #do test
        @client.findUser {}, (err, users) =>
          targetUser = users[0]

          @client.findUser {_id: targetUser.id}, (err, users) ->
            users[0].firstName.should.eql targetUser.firstName
            users[0].lastName.should.eql targetUser.lastName
            users[0].email.should.eql targetUser.email
            users[0].role.should.eql targetUser.role
            users[0].websites.should.eql targetUser.websites
            users[0].departments.should.eql targetUser.departments
            users[0].id.should.eql targetUser.id

            done()