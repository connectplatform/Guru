stoic = require 'stoic'
{Session, Chat} = stoic.models

module.exports = (sessionId, chatId, cb) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    Chat(accountId).allChats.ismember chatId, (err, chatExists) ->
      return cb 'invalid or expired chat Id' unless chatExists.toString() is '1'
      cb()
