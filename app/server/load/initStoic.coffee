stoic = require 'stoic'

stoic.init()
stoic.load config.require "models/#{model}" for model in [
  'sessions'
  'chats'
  'chatSession'
]

module.exports = stoic
