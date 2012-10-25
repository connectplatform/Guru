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

module.exports = ({message, obj}, done) ->
  severity = 'info'
  severity = 'warn' if obj?.severity is 'warn'
  severity = 'error' if obj?.severity is 'error'

  Session.accountLookup.get res.cookie('session'), (err, accountId) ->

    if (getType obj?.ids) is 'Object'
      async.parallel [
        getData accountId, 'Chat', obj.ids.chatId
        getData accountId, 'Session', obj.ids.sessionId

      ], (err, results) ->

        config.log.client[severity] message, {clientData: obj, retrievedData: results}
        done null, 'Success'
    else
      config.log.client[severity] message, {clientData: obj}
      done null, 'Success'
