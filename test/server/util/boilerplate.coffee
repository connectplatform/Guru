# pick a port that server and client will run on
process.env.GURU_PORT = Math.floor(Math.random() * 1000) + 8000
process.env.GURU_PULSAR_PORT = Math.floor(Math.random() * 1000) + 8000

db = config.require 'server/load/mongo'
flushCache = config.require 'load/flushCache'
sampleData = config.require 'policy/sampleData'
stoic = require 'stoic'

#Helper functions
helpers = require './helpers'

# singleton helper to start app
initApp = (cb) ->
  return cb() if @app?
  @app = config.require 'load/app'
  @app cb

# globals
global.Factory = config.require 'data/factory'
global.Sample = config.require 'data/sample'
module.exports = global.boiler = (testName, tests) ->
  describe testName, (done)->
    before (done) ->

      # Adding helpers to before context
      @.merge helpers

      # initialize app server
      initApp ->
        done()

    beforeEach (done) ->
      flushCache config.redis.database, config.redis.database, =>
        sampleData (err, data) =>
          throw new Error "when creating sample data:\n#{err.stack}" if err?
          @account = data.accounts[0]
          @accountId = @account._id
          @paidAccountId = data.accounts[1]._id

          @website = data.websites[0]
          @ownerUser = data.operators[1]
          done()

    after (done) ->
      flushCache config.redis.database, config.redis.database, ->
        db.wipe done

    afterEach ->
      @client.disconnect() if @client?.connected

    tests()
