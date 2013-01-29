Vein = require 'vein'

# accept an http server which we will attach to
module.exports = (server) ->
  vein = Vein.createServer server

  # TODO: When vein connection is lost remove user session

  # accept a set of services
  (services) ->
    Object.map services, (name, service) ->

      # wrap each service in a vein signature and attach it to vein
      vein.add name, (res, args) ->

        # run the service
        service args, (err, result...) ->

          # Log the error and convert it to a string.  Vein doesn't serialize errors correctly.
          if err
            if config.env is 'production'
              config.log.info "#{name} service returned an error: '#{err.message || err}'.", {error: err, args: args}
            err = err.message || err

          res.reply err, result...
