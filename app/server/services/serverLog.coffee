async = require 'async'
stoic = require 'stoic'
{Chat, Session} = stoic.models

{inspect} = require 'util'
{getType} = config.require 'load/util'

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
  return res.reply null, 'Success' unless (getType obj?.ids) is 'Object'

  async.parallel [
    getData obj.ids.chatId, 'Chat'
    getData obj.ids.sessionId, 'Session'

  ], (err, results) ->

    console.log result for result in results
    console.log '\n'
    res.reply null, 'Success'
