stoic = require 'stoic'
{Session} = stoic.models
async = require 'async'

module.exports = (cb) ->
  Session.onlineOperators.card (err, card) ->
    config.log.error 'Error getting online operator count', {error: err} if err
    cb card > 0
