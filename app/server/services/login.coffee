db = config.require 'load/mongo'
{User} = db.models

module.exports =
  required: ['email', 'password']
  service: ({email, password}, done) ->

    getOrCreateSession = config.service 'operator/getOrCreateSession'

    User.findOne {email: email}, (err, user) ->
      if err
        config.log.error 'Error searching for operator in login', {error: err, email: email} if err
        return done err.message

      return done 'Invalid user.' unless user?
      return done 'Invalid password.' unless user.comparePassword password
      return done 'User not associated with accountId.' unless user.accountId # disables admin login

      getOrCreateSession user, (err, {sessionId}) ->
        return done "Could not get session: #{err}" if err or not sessionId

        done err, {sessionId: sessionId}
