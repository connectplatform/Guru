stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (res, chatId) ->
  Chat.get(chatId).visitor.get "referrerData", (err, {websiteUrl}) ->
    res.reply null, "" unless websiteUrl?
    console.log "err: ", err
    console.log "websiteUrl: |#{websiteUrl}|"
    console.log "encoded websiteUrl: |#{encodeURIComponent websiteUrl}|"
    logoUrl = "http://#{config.app.aws.s3.bucket}.s3.amazonaws.com/#{encodeURIComponent websiteUrl}/logo"
    console.log 'logoUrl: ', logoUrl
    res.reply err, logoUrl
