stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (args, cookies, cb) ->
  [chatId] = args
  return cb 'expects chatId argument' unless chatId?

  Chat.allChats.ismember chatId, (err, chatExists) ->
    return cb 'invalid or expired chat Id' unless chatExists is 1
    cb()
