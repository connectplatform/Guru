require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Delete User', ->

  it 'should delete the user with the specified id', (done) ->
    @getAuthed =>

      #Get the user that we are going to delete
      @client.findUser {firstName: 'First'}, (err, [targetUser]) =>
        #log to make sure changing the db seed will cause reasonable failures
        console.log "error finding user... not deleteUser's fault that test failed" if err? or not targetUser?

        #Now delete the user
        @client.deleteUser targetUser.id, (err) =>
          false.should.eql err?

          #check whether it worked
          @client.findUser {}, (err, users) ->
            for user in users
              user.id.should.not.eql targetUser.id
              user.firstName.should.not.eql targetUser.firstName
            done()