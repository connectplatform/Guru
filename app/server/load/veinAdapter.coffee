Vein = require 'vein'

# accept an http server which we will attach to
module.exports = (server) ->
  vein = Vein.createServer server: server

  # TODO:When vein connection is lost remove user session

  # accept a set of services
  (services) ->
    Object.map services, (name, service) ->

      # wrap each service in a vein signature and attach it to vein
      vein.add name, (res, args) ->

        # define a function to process side effects
        processSideEffects = (effects, next) ->
          if effects?.setCookie?.sessionId
            res.cookie 'session', effects.setCookie.sessionId
          next()

        # merge cookies into args
        params = {sessionId: res.cookie 'session'}.merge args

        # run the service
        service params, res.reply, processSideEffects
