module.exports = (res, escapedId) ->
  id = unescape escapedId
  redis = require '../../redis'

  #TODO: make sure the current user is in the chat before letting them access history
  redis.chats.history id, (err, data)->
    if err
      console.log "error recovering history for chat #{id}: #{err}"
      res.send "could not find chat", null
    else
      res.send null, data
