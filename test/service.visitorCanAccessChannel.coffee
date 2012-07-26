should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Visitor Can Access Channel', ->

  it 'should say a visitor can connect to a chat that they created', (done) ->
    @newChat =>
      @client.visitorCanAccessChannel @client.cookie('session'), @channelName, (err, accessAllowed) =>
        should.not.exist err
        accessAllowed.should.eql true
        done()

  it 'should not let a visitor access a channel they were kicked from', (done) ->
    kickUser = require '../server/domain/_services/kickUser'
    @newChat =>
      mockRes = send: =>
        #This will be executed after the kick
        @client.visitorCanAccessChannel @client.cookie('session'), @channelName, (err, accessAllowed) =>
          should.not.exist err
          accessAllowed.should.eql true
          done()

      kickUser mockRes, @channelName
