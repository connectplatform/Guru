stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = ({chatId, sessionId}, done) ->

  newMeta =
    type: 'member'
    isWatching: 'false'

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.mset newMeta, (err) ->
      done err, chatId
