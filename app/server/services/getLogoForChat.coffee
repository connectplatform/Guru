stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (res, chatId) ->
  Chat.get(chatId).website.get (err, website) ->
    console.log "Error getting website:", err if err or not website
    res.reply err, "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{encodeURIComponent website}/logo"
