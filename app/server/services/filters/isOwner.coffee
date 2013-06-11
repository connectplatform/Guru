db = config.require 'load/mongo'
{Session, User} = db.models

module.exports = (args, next) ->
  config.services['getMyRole'] args, (err, {role}) ->
    return next err if err

    err = unless role is 'Owner'
      new Error 'You must be an account Owner to access this feature.'
    else
      null

    next err, args
