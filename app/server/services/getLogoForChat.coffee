stoic = require 'stoic'
{Session, Chat} = stoic.models

module.exports = ({chatId, sessionId}, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    Chat(accountId).get(chatId).website.get (err, website) ->
      if err or not website
        config.log.error 'Error getting website in getLogoForChat', {error: err, chatId: chatId} if err
        return done err, null
      done err, "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{encodeURIComponent website}/logo"
