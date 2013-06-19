async = require 'async'
{curry} = config.require 'load/util'

module.exports =
  required: ['sessionSecret']
  service: (args, done) ->
    async.parallel [
      curry config.services['particle/mySessionPayload'], args
      curry config.services['operator/getChatMembership'], args

    ], (err, [{data: [session]}, {chatIds}]) ->

      done err, {session, chatIds}
