should = require 'should'

boiler 'Service - Delete Model', ->

  it 'should delete the model with the specified id', (done) ->
    @getAuthed =>

      #Get the user that we are going to delete
      @client.findModel {queryObject: {firstName: 'First'}, modelName: 'User'}, (err, [targetUser]) =>
        #log to make sure changing the db seed will cause reasonable failures
        config.log.error "error finding user... not deleteModel's fault that test failed" if err? or not targetUser?

        #Now delete the user
        @client.deleteModel {modelId: targetUser.id, modelName: 'User'}, (err) =>
          false.should.eql err?

          #check whether it worked
          @client.findModel {queryObject: {}, modelName: 'User'}, (err, users) =>
            for user in users
              user.id.should.not.eql targetUser.id
              user.firstName.should.not.eql targetUser.firstName
            done()
