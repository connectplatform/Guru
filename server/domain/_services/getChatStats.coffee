async = require 'async'
getInvites = require '../getInvites'

stoic = require 'stoic'
{ChatSession, Chat} = stoic.models

module.exports = (res) ->
  chatSession = ChatSession.get res.cookie 'session'

  async.parallel {
    all: Chat.allChats.all
    unanswered: Chat.unansweredChats.all
    invites: getInvites chatSession

  }, res.reply
