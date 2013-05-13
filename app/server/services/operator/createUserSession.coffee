db = config.require 'load/mongo'
{Session} = db.models

module.exports = (user, next) ->
  username = if user.lastName
    "#{user.firstName} #{user.lastName}"
  else
    "#{user.firstName}"

  accountId = user.accountId.toString()
  Session.create {
    accountId: accountId
    role: user.role
    chatName: username
    operatorId: user.id
  }, next
