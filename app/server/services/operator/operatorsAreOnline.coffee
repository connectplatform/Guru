stoic = require 'stoic'
{Session} = stoic.models

db = require 'mongoose'
{Website} = db.models

async = require 'async'

module.exports = (domain, done) ->
  Website.findOne {url: domain}, {accountId: true}, (err, website) ->
    if err or not website
      message = 'Could not find website for external link.'
      config.log.error message, {error: err}
      return done message

    {accountId} = website
    Session(accountId).onlineOperators.count (err, count) ->
      done err, count > 0
