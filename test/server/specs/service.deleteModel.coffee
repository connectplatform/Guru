should = require 'should'

boiler 'Service - Delete Model', ->

  it 'should delete the model with the specified id', (done) ->
    @getAuthed =>

      #Get the user that we are going to delete
      @client.findModel {queryObject: {firstName: 'First'}, modelName: 'User'}, (err, {data}) =>
        users = data
        should.not.exist err
        [targetUser] = users
        should.exist targetUser, 'could not find user'

        #Now delete the user
        @client.deleteModel {modelId: targetUser.id, modelName: 'User'}, (err) =>
          should.not.exist err

          #check whether it worked
          @client.findModel {queryObject: {}, modelName: 'User'}, (err, {data}) =>
            users = data
            should.not.exist err

            for user in users
              user.id.should.not.eql targetUser.id
              user.firstName.should.not.eql targetUser.firstName
            done()
