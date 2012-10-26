async = require 'async'
stoic = require 'stoic'
{Session} = stoic.models

{inspect} = require 'util'
{getType} = config.require 'load/util'

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

module.exports = ({sessionId, message, context}, done) ->
  severity = 'info'
  severity = 'warn' if context?.severity is 'warn'
  severity = 'error' if context?.severity is 'error'

  Session.accountLookup.get sessionId, (err, accountId) ->

    if (getType context?.ids) is 'Object'
      async.parallel [
        getData accountId, 'Chat', context.ids.chatId
        getData accountId, 'Session', context.ids.sessionId

      ], (err, results) ->

        config.log.client[severity] message, {clientData: context, retrievedData: results}
        done null, 'Success'
    else
      config.log.client[severity] message, {clientData: context}
      done null, 'Success'
