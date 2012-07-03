db = require '../../server/mongo'
flushCache = require '../../lib/flushCache'
seedMongo = require './seedMongo'

# pick a port that server and client will run on
testPort = Math.floor(Math.random() * 1000) + 8000

# initialize vein client
http = require 'http'
Vein = require 'vein'

globals =
  getClient: -> new Vein.Client port: testPort, transports: ['websocket']

# initialize app server
initApp = (cb) ->
  return cb() if @app?
  @app = require '../../server/app'
  @app testPort, cb

module.exports = (testName, tests) ->

  describe testName, (done)->

    before (done) ->
        globals.db = db
        initApp done

    beforeEach (done) ->
      flushCache ->
        seedMongo done

    after (done) ->
      flushCache ->
        db.wipe done

    tests(globals)