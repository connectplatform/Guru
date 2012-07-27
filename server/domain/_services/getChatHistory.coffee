redgoose = require 'redgoose'
{Chat} = redgoose.models

module.exports = (res, id) ->
  Chat.get(id).history.all (err, data) ->
    if err
      console.log "error recovering history for chat #{id}: #{err}"
      res.send "could not find chat", null
    else
      res.send null, data
