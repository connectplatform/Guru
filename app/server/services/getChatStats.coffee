getInvites = config.require 'services/operator/getInvites'

db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionSecret', 'accountId']
  service: ({sessionSecret}, done) ->
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return done err, null if err or not session?

      getInvites session._id, (err, invites) ->
        return done err, null if err

        data =
          unanswered: session.unansweredChats
          unreadMessages: session.unreadMessages
          invites: invites
        done err, data
