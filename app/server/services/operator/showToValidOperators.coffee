async = require 'async'
getAvailableOperators = config.require 'services/operator/getAvailableOperators'
notifySession = config.require 'services/session/notifySession'

stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = ({chatId, website, specialty}, done) ->

  notify = (operator, next) ->
    notifySession operator.id, 'new', true

  getAvailableOperators website, specialty, (err, operators) ->
    return done err, operators if err or operators.length is 0

    # create a chat session for each valid operator
    async.map operators, notify, done
