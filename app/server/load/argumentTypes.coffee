db = require 'mongoose'
{Website, Specialty} = db.models

stoic = require 'stoic'
{Session, Chat} = stoic.models

{getString, getType} = config.require 'load/util'

redisId = /[a-z0-9]{16}/
mongoId = /[a-f0-9]{24}/

module.exports = [
    typeName: 'String'
    validation: (arg, assert) ->
      assert typeof arg is 'string'
    defaultArgs: ['email', 'password', 'isWatching']
  ,
    typeName: 'MongoId'
    validation: (arg, assert) ->
      assert (typeof arg) is 'string' and arg.match mongoId
    defaultArgs: ['userId', 'accountId', 'websiteId', 'specialtyId']
  ,
    typeName: 'RedisId'
    validation: (arg, assert) ->
      assert (typeof arg) is 'string' and arg.match redisId
    defaultArgs: ['chatId', 'sessionId']
  ,
    typeName: 'SessionId'
    validation: (sessionId, assert) ->
      Session.accountLookup.get sessionId, (err, accountId) ->
        assert not err and accountId
    defaultArgs: ['sessionId']
  ,
    typeName: 'ChatId'
    validation: (chatId, assert, {accountId}) ->
      return assert false unless accountId
      Chat(accountId).exists chatId, (err, exists) ->
        assert not err and exists
    defaultArgs: ['chatId']
  ,
    typeName: 'SpecialtyId'
    lookup: ({accountId, specialtyName}, found) ->
      return found() unless accountId and specialtyName
      Specialty.findOne {accountId: accountId, name: specialtyName}, {_id: true}, (err, results) ->
        return found err if err or not results
        found err, results._id
    defaultArgs: ['specialtyId']
  ,
    typeName: 'WebsiteId'
    lookup: ({websiteUrl}, found) ->
      return found() unless websiteUrl
      config.service('websites/getWebsiteIdForDomain') {websiteUrl: websiteUrl}, (err, {websiteId}) ->
        found err, websiteId
    defaultArgs: ['websiteId']
  ,
    typeName: 'WebsiteUrl'
    validation: (arg, assert) ->
      assert arg.match /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}$/
    defaultArgs: ['websiteUrl']
  ,
    typeName: 'AccountId'
    lookup: ({sessionId, websiteId}, found) ->
      #return found "Could not look up AccountId. No SessionId or WebsiteId provided." unless sessionId or websiteId
      return found() unless sessionId or websiteId

      if sessionId
        Session.accountLookup.get sessionId, found

      else if websiteId
        Website.findOne {_id: websiteId}, {accountId: true}, (err, website) ->
          found err, website?.accountId

    defaultArgs: ['accountId']
  ,
    typeName: 'WebsiteImageName'
    validation: (imageName, assert) ->
      assert imageName in ['online', 'offline', 'logo']
    defaultArgs: ['imageName']
]
