should = require 'should'
db = config.require 'load/mongo'
{Chat, ChatSession} = db.models

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
            Chat.findById @chatId, (err, chat) =>
              should.not.exist err
              should.exist chat
              chat.status.should.equal 'Vacant'
              done()

  it "should should not blow up if the visitor has already left", (done) ->
    # Setup
    @getAuthed (_..., accountId) =>

      # When a visitor creates a chat
      @newVisitor {websiteUrl: 'foo.com'}, (err, visitor) =>
        should.not.exist err

        # And leaves the chat
        visitor.leaveChat {chatId: @chatId}, (err) =>
          should.not.exist err

          # And an Operator joins the chat
          @client.joinChat {chatId: @chatId}, (err) =>
            should.not.exist err

            # When he kicks the user
            @client.kickUser {chatId: @chatId}, (err) =>

              # Then we should get an error
              should.exist err
              err.should.equal 'Chat has no Visitor as a member'
              done()

  it "should not blow up if an Operator tries to kick a Visitor from a vacant Chat", (done) ->
    # Setup
    @getAuthed (_..., accountId) =>

      # When a visitor creates a chat
      @newVisitor {websiteUrl: 'foo.com'}, (err, visitor) =>
        should.not.exist err

        # And leaves the chat
        visitor.leaveChat {chatId: @chatId}, (err) =>
          should.not.exist err

          # When he kicks the user
          @client.kickUser {chatId: @chatId}, (err) =>

            # Then we should get an error
            should.exist err
            err.should.equal 'Chat has no Visitor as a member'
            done()
