stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (done) ->
  Chat.unansweredChats.count (err, chatCount) ->
    message = {count: chatCount}
    event = 'unansweredChats'
    done err, event, message
