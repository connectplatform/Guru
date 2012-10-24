async = require 'async'
{tandoor} = config.require 'load/util'

stoic = require 'stoic'
{Chat, Session, ChatSession} = stoic.models

filterRelevant = config.require 'services/chats/filterRelevant'

module.exports = tandoor (accountId, sessionId, done) ->

  # function to get full data
  getData = (chatId, next) ->
    Chat(accountId).get(chatId).dump next

  # get a list of chats for this account
  Chat(accountId).unansweredChats.all (err, chatIds) ->
    if err or not chatIds
      message = "Could not access unanswered chats."
      config.log.error message, {error: err, accountId: accountId}
      return done message

    # get full data
    async.map chatIds, getData, (err, chatData) ->

      # find out which are relevant to me
      filterRelevant accountId, sessionId, chatData, (err, unanswered) ->
        unansweredIds = unanswered.map (u) -> u.id

        # set my session data
        async.forEach unansweredIds, Session(accountId).get(sessionId).unansweredChats.add, done
