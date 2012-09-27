async = require 'async'
getAvailableOperators = config.require 'services/operator/getAvailableOperators'
notifySession = config.require 'services/session/notifySession'

stoic = require 'stoic'
{Session} = stoic.models

module.exports = ({chatId, website, specialty}, done) ->

  notify = (op, next) ->
    Session.get(op.sessionId).unansweredChats.add chatId, next

  getAvailableOperators website, specialty, (err, operators) ->
    return done err, operators if err or operators.length is 0

    # create a chat session for each valid operator
    async.map operators, notify, done
