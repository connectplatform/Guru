stoic = require 'stoic'
{Chat} = stoic.models
queryChat = config.require 'services/queries/query'

module.exports = ({accountId, chatId}) ->
  queryChat {
    accountId: accountId
    chatId: chatId
    queries:
      visibleStaff:
        where:
          role: '!Visitor'
          isWatching: 'false'
      visitors: where: role: 'Visitor'

  }, ({visibleStaff, visitors}) ->

    if visitors.length is 0
      status = 'vacant'
    else if visibleStaff.length is 0
      status = 'waiting'
    else
      status = 'active'

    Chat(accountId).get(chatId).status.set status, (err) ->
      config.log.error 'Error setting chat status in updateChatStatus', {error: err, accountId: accountId, chatId: chatId}
      cb err
