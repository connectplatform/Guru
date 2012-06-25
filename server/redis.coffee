redback = require('redback').createClient()
async = require 'async'
config = require './config'

loadModel = (name) -> redback.addStructure name, require "./domain/_cache/#{name}"

loadModel "ChatHistory"

module.exports = redback
