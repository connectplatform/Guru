stoic = require 'stoic'
{Session} = stoic.models

module.exports = (user, next) ->
  username = if user.lastName
    "#{user.firstName} #{user.lastName}"
  else
    "#{user.firstName}"

  Session.create {
    role: user.role,
    chatName: username,
    operatorId: user.id
  }, next
