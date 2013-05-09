async = require 'async'
# stoic = require 'stoic'

{inspect} = require 'util'
{getType} = config.require 'load/util'
# {Session} = stoic.models

getData = (accountId, modelName, item) ->
  (cb) ->
    result = ''
    Model = stoic.models[modelName]

    Model(accountId).get(item).dump (err, data) ->
      if err
        result = "Error dumping #{modelName}: " + err if err
      else
        result = "Dump for #{modelName}: " + inspect data
      cb null, result

module.exports =
  optional: ['sessionId', 'accountId']
  required: ['message', 'context']
  service: ({sessionId, accountId, message, context}, done) ->
    severity = 'info'
    severity = 'warn' if context?.severity is 'warn'
    severity = 'error' if context?.severity is 'error'

    message = "Client error: #{message}"

    if (getType context?.ids) is 'Object'
      async.parallel [
        getData accountId, 'Chat', context.ids.chatId
        getData accountId, 'Session', context.ids.sessionId

      ], (err, results) ->

        config.log.client[severity] message, {clientData: context, retrievedData: results}
        done()
    else
      config.log.client[severity] message, {clientData: context}
      done()
