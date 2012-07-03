module.exports = (res, escapedId) ->
  id = unescape escapedId
  redis = require '../../redis'
  redis.chats.history id, (err, data)->
    if err
      console.log "error recovering history for chat #{id}: #{err}"
      res.send "could not find chat", null
    else
      res.send null, data