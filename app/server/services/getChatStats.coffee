async = require 'async'
getInvites = config.require 'services/operator/getInvites'

# stoic = require 'stoic'
# {Session} = stoic.models

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    session = Session(accountId).get sessionId

    async.parallel {
      unreadMessages: session.unreadMessages.getall
      unanswered: session.unansweredChats.all
      invites: getInvites sessionId
    }, done
