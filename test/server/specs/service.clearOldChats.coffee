should = require 'should'

{Chat} = config.require('load/mongo').models
clearOldChats = config.require 'services/clearOldChats'

boiler 'Service - Clear Old Chats', ->
  # beforeEach (done) ->
  #   @clearOldChats = config.require 'services/clearOldChats'
  #   console.log {@clearOldChats}
  #   @guru1Login (err, @guru1) =>
  #     done()
    
  it "should not archive an Active chat", (done) ->
    Factory.create 'chat', {status: 'Active'}, (err, chat) =>
      should.not.exist err
      should.exist chat
      chat.status.should.equal 'Active'
      
      clearOldChats () =>
        Chat.findById chat._id, (err, chat) =>
          should.not.exist err
          should.exist chat
          chat.status.should.equal 'Active'
          
          done()
    
  it "should archive a Vacant chat", (done) ->
    Factory.create 'chat', {status: 'Vacant'}, (err, chat) =>
      should.not.exist err
      should.exist chat
      chat.status.should.equal 'Vacant'

      clearOldChats () =>
        Chat.findById chat._id, (err, chat) =>
          should.not.exist err
          should.exist chat
          chat.status.should.equal 'Archived'
        
          done()

  it "should archive a Waiting chat that has exceeded minutesToTimeout", (done) ->
    minutesToTimeoutInMs = config.app.chats.minutesToTimeout * 60 * 1000
    oneDayInMs = 24*60*60*1000
    staleTimestamp = new Date(Date.now() - minutesToTimeoutInMs - oneDayInMs)
    data =
      status: 'Waiting'
      history:
        [
          message: 'This should be very old'
          username: 'Visitor'
          timestamp: staleTimestamp
        ]
    Factory.create 'chat', data, (err, chat) =>
      should.not.exist err
      should.exist chat
      chat.status.should.equal 'Waiting'

      clearOldChats () =>
        Chat.findById chat._id, (err, chat) =>
          should.not.exist err
          should.exist chat
          chat.status.should.equal 'Archived'
          
          done()


  it "should not archive a Waiting chat that is still fresh", (done) ->
    data =
      status: 'Waiting'
      history:
        [
          message: 'This should not be very old'
          username: 'Visitor'
          timestamp: new Date()
        ]
    Factory.create 'chat', data, (err, chat) =>
      should.not.exist err
      should.exist chat
      chat.status.should.equal 'Waiting'

      clearOldChats () =>
        Chat.findById chat._id, (err, chat) =>
          should.not.exist err
          should.exist chat
          chat.status.should.equal 'Waiting'
          
          done()
