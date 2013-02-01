db = require 'mongoose'
{Website, Specialty} = db.models

stoic = require 'stoic'
{Session, Chat} = stoic.models

{getString, getType} = config.require 'load/util'

redisId = /[a-z0-9]{16}/
mongoId = /[a-f0-9]{24}/

module.exports = [
    typeName: 'String'
    validation: ({value}, assert) ->
      assert typeof value is 'string'
    defaultArgs: ['email', 'password', 'isWatching']
  ,
    typeName: 'MongoId'
    validation: ({value}, assert) ->
      assert getType(value) is 'String' and value.match value
    defaultArgs: ['userId', 'accountId', 'websiteId', 'specialtyId']
  ,
    typeName: 'RedisId'
    validation: ({value}, assert) ->
      assert getType(value) is 'String' and value.match value
    defaultArgs: ['chatId', 'sessionId']
  ,
    typeName: 'SessionId'
    validation: ({value}, assert) ->
      Session.accountLookup.get value, (err, accountId) ->
        assert not err and accountId
    defaultArgs: ['sessionId']
  ,
    typeName: 'ChatId'
    validation: ({value, args: {accountId}}, assert) ->
      return assert false, {reason: 'missing accountId'} unless accountId
      Chat(accountId).exists value, (err, exists) ->
        exists = not err and exists
        assert exists, {reason: 'chatId does not exist'}
    defaultArgs: ['chatId']
  ,
    typeName: 'SpecialtyId'
    lookup: ({accountId, specialtyName}, found) ->
      return found() unless accountId and specialtyName
      Specialty.findOne {accountId: accountId, name: specialtyName}, {_id: true}, (err, results) ->
        found err, results?._id
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
    validation: ({value}, assert) ->
      assert value.match /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}$/
    defaultArgs: ['websiteUrl']
  ,
    typeName: 'AccountId'
    lookup: ({sessionId, websiteId}, found) ->
      return found() unless sessionId or websiteId

      if sessionId
        Session.accountLookup.get sessionId, found

      else if websiteId
        Website.findOne {_id: websiteId}, {accountId: true}, (err, website) ->
          found err, website?.accountId

    defaultArgs: ['accountId']
  ,
    typeName: 'WebsiteImageName'
    validation: ({value}, assert) ->
      assert value in ['online', 'offline', 'logo']
    defaultArgs: ['imageName']
]
