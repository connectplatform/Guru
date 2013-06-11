{User} = config.require('load/mongo').models
should = require 'should'

boiler 'Service - Delete Model', ->

  it 'should delete the model with the specified id', (done) ->
    @getAuthed =>

      # Get the user that we are going to delete
      User.findOne {firstName: 'First'}, (err, targetUser) =>
        should.not.exist err
        should.exist targetUser, 'could not find user'

        # Now delete the user
        @client.deleteModel {modelId: targetUser.id, modelName: 'User'}, (err) =>
          should.not.exist err

          # Check whether it worked
          User.findOne {firstName: 'First'}, (err, user) =>
            should.not.exist err
            should.not.exist user

            done()

  it "should do nothing if I'm an owner for a different account", (done) ->
    Factory.create 'account', (err, account) =>
      return done err if err
      Factory.create 'owner', {accountId: account.id}, (err, owner) =>
        return done err if err

        @getAuthedWith {email: owner.email, password: 'foobar'}, (err) =>
          should.not.exist err

          # Get the user that we are going to delete
          User.findOne {firstName: 'First'}, (err, user) =>
            should.not.exist err
            should.exist user, 'could not find user'

            # Now delete the user
            @client.deleteModel {modelId: user.id, modelName: 'User'}, (err, {status}) =>
              should.not.exist err
              should.not.exist status
              done()
