db = config.require 'load/mongo'
{User} = db.models

module.exports =
  dependencies:
    services: ['operator/getOrCreateSession']
  required: ['email', 'password']
  service: ({email, password}, done, {services}) ->
    getOrCreateSession = services['operator/getOrCreateSession']

    User.findOne {email: email}, (err, user) ->
      if err
        config.log.error 'Error searching for operator in login', {error: err, email: email}
        return done err
      return done (new Error 'Invalid user.') unless user?
      return done (new Error 'Invalid password.') unless user.comparePassword password
      return done (new Error 'User not associated with accountId.') unless user.accountId # disables admin login

      getOrCreateSession user, (err, {sessionSecret}) ->
        return done (new Error "Could not get session: #{err}") if err or not sessionSecret

        done err, {sessionSecret}
