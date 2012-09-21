db = config.require 'server/load/mongo'
flushCache = config.require 'services/flushCache'
sampleData = config.require 'policy/sampleData'
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
  @app = config.require 'load/app'
  @app cb

module.exports = global.boiler = (testName, tests) ->

  describe testName, (done)->

    before (done) ->
      @getClient = -> Vein.createClient port: testPort
      @getPulsar = -> Pulsar.createClient port: pulsarPort
      @db = db

      @getAuthed = (cb) =>
        loginData =
          email: 'admin@foo.com'
          password: 'foobar'
        @getAuthedWith loginData, cb

      @getAuthedWith = (data, cb) =>
        @client = @getClient()
        @client.ready =>
          @client.login data, cb

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
      flushCache =>
        sampleData (err, data) =>
          @adminUser = data[0][0]
          console.log 'error:', err if err?
          #console.log 'sampleData:', data
          done()

    after (done) ->
      flushCache ->
        db.wipe done

    tests()
