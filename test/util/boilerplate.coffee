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
      @getClient = -> new Vein.Client port: testPort, transports: ['websocket']
      @getPulsar = -> new Pulsar.Client port: pulsarPort, transports: ['websocket']
      @db = db
      initApp done

    beforeEach (done) ->
      @client = @getClient()
      @getAuthed = (cb) =>
        loginData =
          email: 'god@torchlightsoftware.com'
          password: 'foobar'
        @client.login loginData, cb
      @client.ready (services) ->
        flushCache ->
          seedMongo done

    afterEach (done) ->
      @client.cookie 'session', null
      @client.cookie 'channel', null
      @client.disconnect()
      done()

    after (done) ->
      flushCache ->
        db.wipe done

    tests()
