stoic = require 'stoic'
{Session} = stoic.models

filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  Session.get(sessionId).unreadMessages.getall (err, chats={}) ->
    message = chats
    event = 'unreadMessages'
    done err, event, message
