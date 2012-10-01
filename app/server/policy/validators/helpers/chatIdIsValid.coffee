stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (chatId, cb) ->
  Chat.allChats.ismember chatId, (err, chatExists) ->
    return cb 'invalid or expired chat Id' unless ((chatExists is '1') or (chatExists is 1))
    cb()
