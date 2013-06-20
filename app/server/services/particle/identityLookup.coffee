async = require 'async'
{curry} = config.require 'lib/util'

module.exports =
  required: ['sessionSecret']
  service: (args, done) ->
    async.parallel [
      curry config.services['particle/mySessionPayload'], args
      curry config.services['operator/getChatMembership'], args

    ], (err, [{data: [session]}, {chatIds, chatRelation}]) ->

      done err, {session, chatIds, chatRelation}
