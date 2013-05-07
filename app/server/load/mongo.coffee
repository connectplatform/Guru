db = require 'mongoose'
async = require 'async'

loadModel = (name) ->
  schema = config.require "models/#{name}"
  schema.path('_id').get (_id) -> _id.toString() # convert objectIDs to strings
  db.model name, schema

db.connect config.mongo.host
db.connection.on 'error', (error) ->
  config.log.error "Uncaught mongoose error.", {error: error}

loadModel "User"
loadModel "Specialty"
loadModel "Website"
loadModel "ChatHistory"
loadModel "Account"
loadModel "Session"

db.wipe = (cb) ->
  async.parallel (m.remove.bind m, null for _, m of db.models), cb

module.exports = db
