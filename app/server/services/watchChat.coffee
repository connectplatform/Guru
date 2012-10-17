#TODO this is 5 characters different from joinChat.  Refactor.
stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = (res, chatId) ->
  sessionId = res.cookie 'session'
  relationMeta =
    isWatching: 'true'
    type: 'member'
  ChatSession.add sessionId, chatId, relationMeta, (err) ->
    config.log.error 'Error adding ChatSession in watchChat', {error: err, sessionId: sessionId, chatId: chatId, relationMeta: relationMeta} if err
    res.reply null, true
