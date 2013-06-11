should = require 'should'

db = config.require 'load/mongo'
{ChatSession} = db.models

boiler 'Service - Accept Chat', ->

  it 'should join the operator into the chat', (done) ->
    @getAuthed =>
      @newChat =>
        @client.acceptChat {sessionId: @sessionId, chatId: @chatId}, (err, result) =>
          should.not.exist err
          result.status.should.eql "OK"
          result.chatId.should.eql @chatId

          ChatSession.findOne {@chatId}, (err, chatSession) =>
            should.not.exist err
            should.exist chatSession
            chatSession.chatId.should.equal @chatId
            done()

          # chan = @getPulsar().channel @chatId
          # message = 'accept chat worked'

          # chan.once 'serverMessage', (data) ->
          #   data.message.should.eql message
          #   done()

          # send test data
          # @client.say {sessionId: @sessionId, chatId: @chatId, message: message}, ->

  it 'should only let one operator accept the chat', (done) ->
    @guru1Login (err, client, {sessionId}) =>

      @newChat (err, data) =>
        should.not.exist err
        should.exist data

        client.acceptChat {sessionId: sessionId, chatId: @chatId}, (err, result) =>
          should.not.exist err
          result.status.should.eql "OK"

          @guru2Login (err, client, params) =>
            newSessionId = params.sessionId
            client.acceptChat {sessionId: newSessionId, chatId: @chatId}, (err, result) =>
              should.not.exist err
              result.status.should.eql "ALREADY ACCEPTED"
              done()

  it 'should decrement my waiting chats count', (done) ->
    @guru1Login (err, client, {sessionId}) =>

      @newChat (err, data) =>
        should.not.exist err
        should.exist data

        client.acceptChat {sessionId: sessionId, chatId: @chatId}, (err, result) =>
          should.not.exist err
          result.status.should.eql "OK"
          client.getChatStats {sessionId: sessionId}, (err, {unanswered}) ->
            should.not.exist err
            should.exist unanswered
            unanswered.length.should.eql 0, 'expected no unanswered chats'

            done()

  it 'should set my visible status to true', (done) ->
    getVisibleOperators = config.require 'services/chats/getVisibleOperators'

    @getAuthed =>
      @newChat =>
        @client.acceptChat {@sessionId, @chatId}, (err, result) =>
          should.not.exist err
          should.exist result
          getVisibleOperators @chatId, (err, operators) =>
            should.not.exist err
            should.exist operators
            operators.length.should.equal 1
            [me] = operators
            me.firstName.should.equal 'Owner'
            me.lastName.should.equal 'Man'
            done()
