async = require 'async'
stoic = require 'stoic'
{Chat, Session} = stoic.models

{inspect} = require 'util'

getData = (item, modelName) ->
  (cb) ->
    result = ''
    model = stoic.models[modelName]

    model.get(item).dump (err, data) ->
      if err
        result = "Error dumping #{modelName}: " + err if err
      else
        result = "Dump for #{modelName}: " + inspect data
      cb null, result

module.exports = (res, obj) ->
  console.log '\nReceived logging request from client: ', obj

  async.parallel [
    getData obj.chatId, 'Chat'
    getData obj.sessionId, 'Session'

  ], (err, results) ->

    console.log result for result in results
    console.log '\n'
    res.reply null, 'Success'
