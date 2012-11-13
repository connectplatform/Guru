stoic = require 'stoic'
{Session} = stoic.models

module.exports = ({accountId}, done) ->
  Session(accountId).onlineOperators.count (err, count) ->
    done err, count > 0
