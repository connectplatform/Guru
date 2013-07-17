db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  dependencies:
    services: ['operator/getInvites']
  required: ['sessionSecret', 'accountId']
  service: ({sessionSecret}, done, {services}) ->
    getInvites = services['operator/getInvites']
    
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return done err, null if err or not session?

      getInvites {sessionId: session._id}, (err, {invites}) ->
        return done err, null if err

        data =
          unanswered: session.unansweredChats
          unreadMessages: session.unreadMessages
          invites: invites
        done err, data
