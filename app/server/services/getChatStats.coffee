async = require 'async'
getInvites = config.require 'services/operator/getInvites'

stoic = require 'stoic'
{Session} = stoic.models

module.exports = (res) ->
  sessionId = res.cookie 'session'
  session = Session.get sessionId

  async.parallel {
    unreadMessages: session.unreadMessages.getall
    unanswered: session.unansweredChats.all
    invites: getInvites sessionId

  }, res.reply
