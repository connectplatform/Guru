stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (res, chatId) ->
  Chat.get(chatId).visitor.get "referrerData", (err, referrerData={}) ->
    console.log "Error getting referrer data: ", err if err?
    {websiteUrl} = referrerData
    res.reply null, "" unless websiteUrl?
    res.reply err, "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{encodeURIComponent websiteUrl}/logo"
