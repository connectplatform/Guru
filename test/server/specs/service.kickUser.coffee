should = require 'should'

boiler 'Service - Kick User', ->

  it 'should remove visitor from chat', (done) ->
    # Setup
    @getAuthed (_..., {accountId}) =>
      @newChat =>
        @client.joinChat {chatId: @chatId}, (err) =>
          should.not.exist err

          # Kick user
          @client.kickUser {chatId: @chatId}, (err) =>
            should.not.exist err

            # Check that kick worked
            {Chat} = stoic.models
            Chat(accountId).get(@chatId).status.get (err, status) =>
              should.not.exist err
              status.should.eql 'vacant'
              done()

  it "should should not puke if the visitor has already left", (done) ->
    # Setup
    @getAuthed (_..., accountId) =>

      # When a visitor creates a chat
      @newVisitor {websiteUrl: 'foo.com'}, (err, visitor) =>

        # And leaves the chat
        visitor.leaveChat {chatId: @chatId}, (err) =>

          # And an Operator joins the chat
          @client.joinChat {chatId: @chatId}, (err) =>
            should.not.exist err

            # When he kicks the user
            @client.kickUser {chatId: @chatId}, (err) =>

              # Then we should get an error
              should.not.exist err
              done()
