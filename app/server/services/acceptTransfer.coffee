async = require 'async'
stoic = require 'stoic'
{ChatSession} = stoic.models

pulsar = config.require 'load/pulsar'

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({sessionId, accountId, chatId}, done) ->

    # find the requestor's sessionId
    chatSession = ChatSession(accountId).get sessionId, chatId
    chatSession.relationMeta.get 'requestor', (err, requestor) ->
      return done err if err

      # switch out the operators
      async.parallel [
        chatSession.relationMeta.mset {type: 'member', isWatching: 'false'}
        ChatSession(accountId).remove requestor, chatId

      ], (err) ->
        return done err if err

        # send notifications and return
        notifySession = pulsar.channel "notify:session:#{requestor}"
        notifySession.emit 'kickedFromChat', chatId

        done null, {chatId: chatId}
