db = require 'mongoose'
async = require 'async'

loadModel = (name) -> db.model name, config.require "models/#{name}"

db.connect config.mongo.host
loadModel "User"
loadModel "Specialty"
loadModel "Website"
loadModel "ChatHistory"
loadModel "Account"

db.wipe = (cb) ->
  async.parallel (m.remove.bind m, null for _, m of db.models), cb

module.exports = db
