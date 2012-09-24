stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (res, chatId) ->
  Chat.get(chatId).visitor.get "referrerData", (err, {websiteUrl}) ->
    res.reply null, "" unless websiteUrl?
    console.log "err: ", err
    logoUrl = "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{encodeURIComponent websiteUrl}/logo"
    console.log 'logoUrl: ', logoUrl
    res.reply err, logoUrl
