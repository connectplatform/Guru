db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['accountId', '_id']
  service: (user, done) ->
    username = if user.lastName
      "#{user.firstName} #{user.lastName}"
    else
      "#{user.firstName}"

    Session.create {
      accountId: user.accountId
      userId: user._id
      username: username
      role: user.role
    }, done