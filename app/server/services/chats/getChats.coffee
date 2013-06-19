{Chat} = config.require('load/mongo').models

module.exports =
  required: ['chatIds']
  service: ({chatIds}, done) ->
    Chat.find {_id: {'$in': chatIds}}, (err, chats=[]) ->
      done err, {chats}
