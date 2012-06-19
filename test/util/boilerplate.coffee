db = require '../../server/mongo'

# pick a port that server and client will run on
testPort = Math.floor(Math.random() * 1000) + 8000

# initialize app server
app = require '../../server/app'
app(testPort)

# initialize vein client
http = require 'http'
Vein = require 'vein'

globals =
  getClient: -> new Vein.Client port: testPort, transports: ['websocket']

module.exports = (testName, tests) ->

  describe testName, (done)->

    before (done) ->
      globals.db = db
      done()

    beforeEach (done) ->
      db.wipe done

    after (done) ->
      db.wipe done

    tests(globals)
