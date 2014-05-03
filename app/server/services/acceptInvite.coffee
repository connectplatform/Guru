stoic = require 'stoic'
{ChatSession} = stoic.models
billing = require "../billing"

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({sessionId, accountId, chatId}, done) ->
    newMeta =
      type: 'member'
      isWatching: 'false'

    billing.accountInGoodStanding {accountId: accountId}, (err, result) ->
      return done(err) if err

      ChatSession(accountId).get(sessionId, chatId).relationMeta.mset newMeta, (err) ->
        done err
