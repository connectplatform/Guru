# this shit basically initializes the app and sets up a test environment
app = require '../../server/app'
app()

http = require 'http'
{inspect} = require 'util'

globals = {}

#initialize vein server
Vein = require 'vein'
randomPort = -> Math.floor(Math.random() * 1000) + 8000
port = randomPort()
serv = new Vein http.createServer().listen port
globals.getClient = -> new Vein.Client port: port, transports: ['websocket']

module.exports = (testName, tests) ->

  {join} = require 'path'
  connect = require 'connect'
  db = require '../../server/mongo'

  describe testName, (done)->

    before (done) ->
      globals.db = db
      done()

    beforeEach (done) ->
      db.wipe done

    after (done) ->
      db.wipe done

    tests(globals)
