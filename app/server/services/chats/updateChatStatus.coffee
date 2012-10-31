stoic = require 'stoic'
{Chat} = stoic.models
queryChat = config.require 'services/queries/query'

module.exports = ({accountId, chatId}, done) ->
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

    console.log 'foo'

    Chat(accountId).get(chatId).status.set status, (err) ->
      config.log.error 'Error setting chat status in updateChatStatus', {error: err, accountId: accountId, chatId: chatId} if err
      done err
