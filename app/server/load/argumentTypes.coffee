db = require 'mongoose'
{Website} = db.models

stoic = require 'stoic'
{Session} = stoic.models

{getString} = config.require 'load/util'

redisId = /[a-z0-9]{16}/

module.exports = [
    typeName: 'String'
    validation: (arg, assert) ->
      assert typeof arg is 'string'
    defaultArgs: ['email', 'password', 'isWatching']
  ,
    typeName: 'SessionId'
    validation: (arg, assert) ->
      assert (typeof arg is 'string') and arg.match redisId
    defaultArgs: ['sessionId']
  ,
    typeName: 'WebsiteId'
    lookup: (args, found) ->
      Website.findOne {websiteUrl: args.websiteUrl}, {_id: true}, (err, site) ->
        found err, getString(site?._id)
    defaultArgs: ['websiteId']
  ,
    typeName: 'WebsiteUrl'
    validation: (arg, assert) ->
      assert arg.match /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}$/
    defaultArgs: ['websiteUrl']
  ,
    typeName: 'AccountId'
    lookup: ({sessionId, websiteId}, found) ->
      return found "Could not look up AccountId. No SessionId or WebsiteId provided." unless sessionId or websiteId

      if sessionId
        Session.accountLookup.get sessionId, found

      else if websiteId
        Website.findOne {_id: websiteId}, {accountId: true}, (err, account) ->
          found err, getString(account?._id)

    defaultArgs: ['accountId']
]
