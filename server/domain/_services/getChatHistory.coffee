module.exports = (res, escapedId) ->
  id = unescape escapedId

  #TODO: make sure the current user is in the chat before letting them access history
  redgoose = require 'redgoose'
  {Chat} = redgoose.models
  Chat.get(id).history.get (err, data)->
    if err
      console.log "error recovering history for chat #{id}: #{err}"
      res.send "could not find chat", null
    else
      res.send null, data