redgoose = require 'redgoose'
{ChatSession} = redgoose.models

{inspect} = require 'util'
module.exports = (req, cb) ->

  [chatId] = req.args
  sessionId = req.cookies.session
  cb false unless chatId? and sessionId?

  ChatSession.get(sessionId, chatId).relationMeta.get 'type', (err, type) ->
    console.log "Error getting type of chatSession in authentication: #{err}" if err
    cb type is 'member'
