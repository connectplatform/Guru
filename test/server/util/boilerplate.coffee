db = config.require 'server/load/mongo'
flushCache = config.require 'load/flushCache'
sampleData = config.require 'policy/sampleData'
stoic = require 'stoic'

# pick a port that server and client will run on
testPort = process.env.GURU_PORT = Math.floor(Math.random() * 1000) + 8000
pulsarPort = process.env.GURU_PULSAR_PORT = Math.floor(Math.random() * 1000) + 8000

# initialize vein client
Vein = require 'vein'
Pulsar = require 'pulsar'

#Helper functions
helpers = require './helpers'

# singleton helper to start app
initApp = (cb) ->
  return cb() if @app?
  @app = config.require 'load/app'
  @app cb

module.exports = global.boiler = (testName, tests) ->

  # Adding helpers to global.boiler
  for helperName, helper of helpers
      do (helperName, helper) =>
        this[helperName] = helper

  describe testName, (done)->
    before (done) ->

      # Adding helpers to before context
      for helperName, helper of helpers
        do (helperName, helper) =>
          this[helperName] = helper

      # initialize app server
      initApp ->
        done()

    beforeEach (done) ->
      flushCache config.redis.database, config.redis.database, =>
        sampleData (err, data) =>
          throw new Error "when creating sample data: #{err}" if err?
          @adminUser = data.operators[0]
          done()

    after (done) ->
      flushCache config.redis.database, config.redis.database, ->
        db.wipe done

    afterEach ->
      @client.disconnect() if @client?.connected

    tests()
