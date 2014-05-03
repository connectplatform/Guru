stoic = require 'stoic'
{ChatSession} = stoic.models
billing = require "../billing"

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  optional: ['isWatching']
  service: ({chatId, isWatching, sessionId, accountId}, done) ->
    relationMeta =
      isWatching: isWatching
      type: 'member'

    billing.accountInGoodStanding {accountId: accountId}, (err, result) ->
      return done(err) if err

      ChatSession(accountId).add sessionId, chatId, relationMeta, (err) ->
        status = if err then 'ERROR' else 'OK'
        done err, {status: status}
