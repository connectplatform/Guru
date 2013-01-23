stoic = require 'stoic'
{Chat} = stoic.models
queryChat = config.require 'services/queries/query'
removeUnanswered = config.require 'services/operator/removeUnanswered'

module.exports =
  required: ['accountId', 'chatId']
  service: ({accountId, chatId}, done) ->
    queryChat {
      accountId: accountId
      queries:
        visibleStaff:
          ids: chatId: chatId
          select: sessionId: 'chatSession.sessionId'
          where:
            'session.role': '!Visitor'
            'chatSession.relationMeta.isWatching': 'false'
        visitors:
          ids: chatId: chatId
          select: sessionId: 'chatSession.sessionId'
          where:
            'session.role': 'Visitor'

    }, (err, {visibleStaff, visitors}) ->

      if visitors.length is 0
        status = 'vacant'
      else if visibleStaff.length is 0
        status = 'waiting'
      else
        status = 'active'

      Chat(accountId).get(chatId).status.getset status, (err, oldStatus) ->
        if err
          meta = {error: err, accountId: accountId, chatId: chatId}
          config.log.error 'Error setting chat status in updateChatStatus', meta

        # refactor this to a state machine if it gets messy
        if oldStatus is 'waiting' and status isnt 'waiting'
          removeUnanswered accountId, chatId, done
        else
          done err
