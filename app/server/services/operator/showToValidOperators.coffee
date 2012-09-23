async = require 'async'
getAvailableOperators = config.require 'services/operator/getAvailableOperators'

stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = ({chatId, website, specialty}, done) ->

  listChat = (operator, next) ->
    ChatSession.add operator.id, chatId, {type: 'new'}, (err, status) ->
      next err, {sessionId: operator.id, chatId: chatId}

  getAvailableOperators website, specialty, (err, operators) ->
    return done err, operators if err or operators.length is 0

    # create a chat session for each valid operator
    async.map operators, listChat, done
