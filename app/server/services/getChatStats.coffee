async = require 'async'
getInvites = config.require 'services/operator/getInvites'

db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    Session.findById sessionId, (err, session) ->
      done err, null if err

      getInvites sessionId, (err, invites) ->
        done err, null if err

        data =
          unanswered: session.unansweredChats
          unreadMessages: session.unreadMessages
          invites: invites
        done err, data
