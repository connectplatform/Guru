# pick a port that server and client will run on
process.env.GURU_PORT = Math.floor(Math.random() * 1000) + 8000
process.env.GURU_PULSAR_PORT = Math.floor(Math.random() * 1000) + 8000

db = config.require 'load/mongo'
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

# data creation
global.Factory = config.require 'data/factory'
global.Sample = config.require 'data/sample'

# prepare data for standard tests
standardDataPrep = (done) ->
  sampleData (err, data) =>
    throw new Error "when creating sample data:\n#{err.stack}" if err?
    @account = data.accounts[0]
    @accountId = @account._id
    @paidAccountId = data.accounts[1]._id

    @website = data.websites[0]
    @ownerUser = data.operators[1]
    done()

# prepare data for recurly tests
recurlyDataPrep = (done) ->
  standardDataPrep.call @, =>
    Factory.create 'paidOwner', done

setup = (testName, dataPrep, tests) ->
  describe testName, (done)->
    before (done) ->

      # Adding helpers to before context
      @.merge helpers

      # initialize app server
      initApp ->
        done()

    beforeEach (done) ->
      flushCache config.redis.database, config.redis.database, =>
        dataPrep.call @, done

    after (done) ->
      flushCache config.redis.database, config.redis.database, ->
        db.wipe done

    afterEach ->
      #console.log "We've run #{++ helpers.count} tests."
      while helpers.clients.length
        client = helpers.clients.pop()
        client.disconnect() if client?.connected

    tests()

module.exports = global.boiler = (testName, tests) ->
  setup testName, standardDataPrep, tests

global.recurlyBoiler = (testName, tests) ->
  setup testName, recurlyDataPrep, tests
