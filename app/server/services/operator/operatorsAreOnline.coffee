stoic = require 'stoic'
{Session} = stoic.models

db = require 'mongoose'
{Website} = db.models

async = require 'async'

module.exports = (siteName, done) ->
  Website.findOne {name: siteName}, {accountId: true}, (err, website) ->
    if err or not website
      message = 'Could not find website for external link.'
      config.log.error message, {error: err}
      return done message

    {accountId} = website
    Session(accountId).onlineOperators.count (err, count) ->
      config.log.error 'Error getting online operator count', {error: err} if err
      done err, count > 0
