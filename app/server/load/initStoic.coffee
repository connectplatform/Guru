stoic = require 'stoic'

stoic.init()
stoic.load config.require "models/#{model}" for model in [
  'sessions'
  'chats'
  'chatSession'
]

run = false
module.exports = (cb) ->
  if run
    cb null, stoic

  else
    run = true
    stoic.client.select config.redis.database, (err) ->
      cb err, stoic
