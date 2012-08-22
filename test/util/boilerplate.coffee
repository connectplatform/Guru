db = require '../../server/mongo'
flushCache = require '../../lib/flushCache'
sampleData = require '../../server/sampleData'
stoic = require 'stoic'
async = require 'async'

# pick a port that server and client will run on
testPort = process.env.GURU_PORT = Math.floor(Math.random() * 1000) + 8000
pulsarPort = process.env.GURU_PULSAR_PORT = Math.floor(Math.random() * 1000) + 8000

# initialize vein client
http = require 'http'
Vein = require 'vein'
Pulsar = require 'pulsar'

# initialize app server
initApp = (cb) ->
  return cb() if @app?
  @app = require '../../server/app'
  @app cb

module.exports = (testName, tests) ->

  describe testName, (done)->

    before (done) ->
      @getClient = -> Vein.createClient port: testPort
      @getPulsar = -> Pulsar.createClient port: pulsarPort
      @db = db

      @getAuthed = (cb) =>
        @client = @getClient()
        loginData =
          email: 'admin@foo.com'
          password: 'foobar'
        @client.ready =>
          @client.login loginData, cb

      @newChat = (cb) =>
        @visitor = @getClient()
        @visitor.ready =>
          data = {username: 'visitor'}
          @visitor.newChat data, (err, data) =>
            @visitorSession = @visitor.cookie 'session'
            throw new Error err if err
            @chatChannelName = data.channel
            @visitor.disconnect()
            cb()

      @createChats = (cb) ->
        {Chat} = stoic.models
        now = Date.create().getTime()

        chats = [
          {
            visitor:
              username: 'Bob'
            status: 'waiting'
            creationDate: now
            history: []
          }
          {
            visitor:
              username: 'Suzie'
            status: 'active'
            creationDate: now
            history: []
          }
          {
            visitor:
              username: 'Ralph'
            status: 'active'
            creationDate: now
            history: []
          }
          {
            visitor:
              username: 'Frank'
            status: 'vacant'
            creationDate: now
            history: []
          }
        ]

        createChat = (chat, cb) ->
          Chat.create (err, c) ->
            async.parallel [
              c.visitor.mset chat.visitor
              c.status.set chat.status
              c.creationDate.set chat.creationDate
              #c.history.rpush chat.history... #this needs to be a loop
            ], (err) -> cb err, c

        async.map chats, createChat, cb

      initApp ->
        done()

    beforeEach (done) ->
      flushCache ->
        sampleData done

    after (done) ->
      flushCache ->
        db.wipe done

    tests()
