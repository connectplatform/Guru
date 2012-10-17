async = require 'async'
stoic = require 'stoic'
{Chat, Session} = stoic.models

{inspect} = require 'util'
{getType} = config.require 'load/util'

getData = (item, modelName) ->
  (cb) ->
    result = ''
    model = stoic.models[modelName]

    model.get(item).dump (err, data) ->
      if err
        result = "Error dumping #{modelName}: " + err if err
      else
        result = "Dump for #{modelName}: " + inspect data
      cb null, result

module.exports = (res, message, obj) ->
  severity = 'info'
  severity = 'warn' if obj?.severity is 'warn'
  severity = 'error' if obj?.severity is 'error'

  if (getType obj?.ids) is 'Object'
    async.parallel [
      getData obj.ids.chatId, 'Chat'
      getData obj.ids.sessionId, 'Session'

    ], (err, results) ->

      config.log.client[severity] message, {clientData: obj, retrievedData: results}
      res.reply null, 'Success'
  else
    config.log.client[severity] message, {clientData: obj}
    return res.reply null, 'Success'
