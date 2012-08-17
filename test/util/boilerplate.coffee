db = require '../../server/mongo'
flushCache = require '../../lib/flushCache'
seedMongo = require '../../server/seedMongo'

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
            throw new Error err if err
            @chatChannelName = data.channel
            @visitor.disconnect()
            cb()

      initApp ->
        done()

    beforeEach (done) ->
      flushCache ->
        seedMongo done

    after (done) ->
      flushCache ->
        db.wipe done

    tests()
