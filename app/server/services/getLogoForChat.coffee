querystring = require 'querystring'
stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (res, chatId) ->
  Chat.get(chatId).visitor.get "websiteUrl", (err, websiteUrl) ->
    res.reply err, "http://#{config.app.aws.s3.bucket}.s3.amazonaws.com/#{querystring.stringify websiteUrl}/logo"
