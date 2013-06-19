async = require 'async'
db = config.require 'load/mongo'

{inspect} = require 'util'
{getType} = config.require 'lib/util'
{Chat, Session} = db.models

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
        (next) -> Chat.findById context.ids.chatId, next
        (next) -> Session.findById context.ids.sessionId, next
      ], (err, results) ->

        config.log.client[severity] message, {clientData: context, retrievedData: results}
        done()
    else
      config.log.client[severity] message, {clientData: context}
      done()
