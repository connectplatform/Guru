should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Get Active Chats', ->

  beforeEach (done) ->
    session = {username: 'foo'}
    client1 = @getClient()
    client1.ready =>

      # create a new chat
      client1.newChat session, (err, {channel}) =>
        client1.disconnect()
        @chatID = channel
        @getAuthed done

  it 'should return data on all existing chats', (done) ->

    # get active chats
    @client.getActiveChats (err, [chatData]) ->
      should.not.exist err
      chatData.visitor.username.should.eql 'foo'
      chatData.status.should.eql 'waiting'
      new Date chatData.creationDate #just need this to not cause an error
      done()

  it 'should return operators for chats', (done) ->

    # have our operator join the chat
    @client.joinChat @chatID, =>

      # get active chats
      @client.getActiveChats (err, [chatData]) ->
        should.not.exist err
        should.exist chatData.operators
        chatData.operators.length.should.eql 1, 'Expected 1 operator in chat'

        done()
