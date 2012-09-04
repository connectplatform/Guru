async = require 'async'
getInvites = config.require 'services/getInvites'

stoic = require 'stoic'
{ChatSession, Chat, Session} = stoic.models

module.exports = (res) ->
  chatSession = ChatSession.get res.cookie 'session'
  session = Session.get res.cookie 'session'

  async.parallel {
    all: Chat.allChats.all
    unreadMessages: session.unreadMessages.getall
    unanswered: Chat.unansweredChats.all
    invites: getInvites chatSession

  }, res.reply
