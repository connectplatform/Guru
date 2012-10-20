async = require 'async'
{tandoor} = config.require 'load/util'

stoic = require 'stoic'
{Chat, Session, ChatSession} = stoic.models

filterRelevant = config.require 'services/chats/filterRelevant'

getData = (chatId, next) ->
  Chat.get(chatId).dump next

module.exports = tandoor (accountId, sessionId, done) ->

  Chat.unansweredChats.all (err, chatIds) ->

    # get full data
    async.map chatIds, getData, (err, chatData) ->

      # find out which are relevant to me
      filterRelevant accountId, sessionId, chatData, (err, unanswered) ->
        unansweredIds = unanswered.map (u) -> u.id

        # set my session data
        async.forEach unansweredIds, Session(accountId).get(sessionId).unansweredChats.add, done
