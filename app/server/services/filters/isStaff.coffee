enums = config.require 'load/enums'

module.exports =
  service: (args, next) ->
    console.log {args}
    config.services['getMyRole'] args, (err, {role}) ->
      console.log {role}
      unless role in enums.staffRoles
        return next new Error "You must login to access this feature."

      next null, args
