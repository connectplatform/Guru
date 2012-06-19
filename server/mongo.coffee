db = require 'mongoose'
async = require 'async'
config = require './config'

loadModel = (name) -> db.model name, require "./domain/_models/#{name}"

db.connect config.mongo.host
loadModel "User"

db.wipe = (cb) ->
  #console.log (m.remove.toString() for _, m of db.models)
  async.parallel (m.remove.bind m, null for _, m of db.models), cb

module.exports = db
