{digest_s} = require 'md5'

stoic = require 'stoic'
{Session} = stoic.models

getOperatorData = config.require 'services/operator/getOperatorData'

# TODO: implement this using required args
#{
  #filters: ['bothArgsAreStrings']
  #only: ['changePassword']
#}
module.exports = ({oldPassword, newPassword, sessionId}, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    getOperatorData accountId, sessionId, (err, user) ->
      config.log.error 'Error getting user from sessionId in changePassword', {error: err, sessionId: sessionId} if err
      return done "User not found." unless user
      return done "Incorrect current password." unless user.password is digest_s oldPassword
      return done 'Invalid password.' unless newPassword
      return done 'New password must be at least 6 characters.' if newPassword.length < 6

      user.password = digest_s newPassword
      user.save (err) ->
        config.log.error "Error saving new password in changePassword: ", {error: err, user: user} if err
        done err
