async = require 'async'
{tandoor} = config.require 'load/util'

stoic = require 'stoic'
{Chat, Session, ChatSession} = stoic.models

filterRelevant = config.require 'services/chats/filterRelevant'

getData = (chatId, next) ->
  Chat.get(chatId).dump next

module.exports = tandoor (sessionId, done) ->
  # get all unanswered
  Chat.unansweredChats.all (err, chatIds) ->

    # get full data
    async.map chatIds, getData, (err, chatData) ->

      # find out which are relevant to me
      filterRelevant sessionId, chatData, (err, unanswered) ->
        unansweredIds = unanswered.map (u) -> u.id

        # set my session data
        async.forEach unansweredIds, Session.get(sessionId).unansweredChats.add, done
