jade = require 'jade'
path = require 'path'

stoic = require 'stoic'
{Chat} = stoic.models

fs = require 'fs'
chatHistoryJade = fs.readFileSync path.join(config.path('views'), 'chatHistory.jade'), 'UTF8'
compiled = jade.compile chatHistoryJade

module.exports = (chatId, cb) ->
  Chat.get(chatId).history.all (err, history) ->
    cb err, compiled history: history
