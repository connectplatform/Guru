enums = config.require 'load/enums'

module.exports =
  service: (args, next) ->
    config.services['getMyRole'] args, (err, {role}) ->
      unless role in enums.staffRoles
        return next new Error "You must login to access this feature."

      next null, args
