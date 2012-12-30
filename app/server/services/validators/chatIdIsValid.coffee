stoic = require 'stoic'
{Session, Chat} = stoic.models

module.exports = (args, next) ->
  {sessionId, chatId} = args
  return next "sessionId required" unless sessionId
  return next "chatId required" unless chatId

  Session.accountLookup.get sessionId, (err, accountId) ->
    return next 'invalid or expired session' if err or not accountId

    Chat(accountId).allChats.ismember chatId, (err, chatExists) ->
      return next 'invalid or expired chat Id' unless chatExists.toString() is '1'
      next null, args
