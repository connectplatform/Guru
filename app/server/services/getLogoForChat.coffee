stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (res, chatId) ->
  Chat.get(chatId).website.get (err, website) ->
    if err or not website
      config.log.error 'Error getting website in getLogoForChat', {error: err, chatId: chatId} if err
      return res.reply err, null
    res.reply err, "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{encodeURIComponent website}/logo"
