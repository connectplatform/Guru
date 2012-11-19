db = require 'mongoose'
async = require 'async'

loadModel = (name) ->
  schema = config.require "models/#{name}"
  schema.path('_id').get (_id) -> _id.toString() # convert objectIDs to strings
  db.model name, schema

db.connect config.mongo.host
loadModel "User"
loadModel "Specialty"
loadModel "Website"
loadModel "ChatHistory"
loadModel "Account"

db.wipe = (cb) ->
  async.parallel (m.remove.bind m, null for _, m of db.models), cb

module.exports = db
