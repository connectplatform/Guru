db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['accountId', '_id']
  service: (user, done) ->
    {accountId} = user
    createUserSession = config.service 'operator/createUserSession'

    # TODO.jkr
    # Session.getSessionByOperator user._id, (err, sess) ->
    Session.findOne user._id, (err, session) ->
      config.log.warn 'Error getting operator session.', {error: err, userId: user._id} if err

      # if sessionId?
      #   session.
        
    
    # Session(accountId).sessionsByOperator.get user._id, (err, sessionId) ->
    #   config.log.warn 'Error getting operator session.', {error: err, userId: user._id} if err

    #   if sessionId?
    #     Session(accountId).get(sessionId).online.set true, (err) ->
    #       if err
    #         meta = {error: err, sessionId: sessionId}
    #         config.log.error 'Error setting operator online status.', meta

    #       done err, {sessionId: sessionId}

    #   else
    #     createUserSession user, (err, session) ->
    #       config.log.warn 'Error creating user session.', {error: err, userId: user._id} if err
    #       done err, {sessionId: session.id}
