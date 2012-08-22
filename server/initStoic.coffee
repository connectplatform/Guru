stoic = require 'stoic'

stoic.init()
stoic.load require model for model in [
  './domain/_models/sessions'
  './domain/_models/chats'
  './domain/_models/chatSession'
]

module.exports = stoic
