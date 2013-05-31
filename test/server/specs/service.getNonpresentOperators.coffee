should = require 'should'

db = config.require 'load/mongo'
{Session} = db.models

boiler 'Service - Get Nonpresent Operators', ->
  it 'should return a list of operators not currently visible in chat', (done) ->
    @guru1Login (err, @guru1Client) =>
      should.not.exist err
      should.exist @guru1Client
      console.log {@guru1Client}
      
      @guru2Login (err, @guru2Client) =>
        should.not.exist err
        should.exist @guru2Client
        console.log {@guru2Client}

        @newChat =>
          @guru1Client.joinChat {@chatId}, (err) =>
            should.not.exist err

            @guru1Client.getNonpresentOperators {@chatId}, (err, {operators}) =>
              should.not.exist err
              should.exist operators

              console.log {operators}
              
              done()
      
    # # Setup
    # @getAuthed (_..., {accountId}) =>
    #   @newChat =>
    #     @client.watchChat {chatId: @chatId}, (err) =>

    #       # Get a list of operators who are online and not visible in chat
    #       @client.getNonpresentOperators {chatId: @chatId}, (err, {operators}) =>
    #         should.not.exist err
    #         should.exist operators

    #         # Validate returned data
    #         operators.length.should.eql 1
    #         [op] = operators
    #         op.username.should.equal 'Owner Man'

    #         done()
    #         # Make sure we have the right id
    #         # Session.findById op._id, (err, sess
    #         # Session(accountId).get(operators[0].id).chatName.get (err, chatName) =>
    #         #   chatName.should.eql 'Owner Man'
    #         #   done()

  it 'should not return operators who are visible in the chat', (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @client.acceptChat {chatId: @chatId}, (err) =>
          should.not.exist err

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators {chatId: @chatId}, (err, {operators}) =>
            should.not.exist err
            should.exist operators

            # Validate returned data
            operators.length.should.eql 0
            done()
