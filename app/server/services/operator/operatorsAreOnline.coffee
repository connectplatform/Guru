stoic = require 'stoic'
{Session} = stoic.models
async = require 'async'

module.exports = (cb) ->
  Session.onlineOperators.card (err, card) ->
    console.log 'Error getting online operators: ', err if err?
    cb card > 0
