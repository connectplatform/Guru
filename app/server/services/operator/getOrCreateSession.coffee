stoic = require 'stoic'
{Session} = stoic.models

module.exports =
  required: ['accountId', '_id']
  service: (user, done) ->
    {accountId} = user
    createUserSession = config.service 'operator/createUserSession'

    Session(accountId).sessionsByOperator.get user._id, (err, sessionId) ->
      config.log.warn 'Error getting operator session.', {error: err, userId: user._id} if err

      if sessionId?
        Session(accountId).get(sessionId).online.set true, (err) ->
          if err
            meta = {error: err, sessionId: sessionId}
            config.log.error 'Error setting operator online status.', meta

          done err, {sessionId: sessionId}

      else
        createUserSession user, (err, session) ->
          config.log.warn 'Error creating user session.', {error: err, userId: user._id} if err
          done err, {sessionId: session.id}
