db = require 'mongoose'
{Chat, ChatSession, Session, Specialty, Website} = db.models

{getString, getType} = config.require 'lib/util'

redisId = /^[a-z0-9]{16}$/
mongoId = /^[a-f0-9]{24}$/

module.exports = [
    typeName: 'String'
    validation: ({value}, assert) ->
      assert typeof value is 'string'
    defaultArgs: ['email', 'password', 'isWatching']
  ,
    typeName: 'Password'
    validation: ({value}, assert) ->
      unless value?.length >= 6
        assert false, 'Password must be at least 6 characters.'
      else
        assert true
    defaultArgs: ['newPassword', 'oldPassword', 'password']
  ,
    typeName: 'MongoId'
    validation: ({value}, assert) ->
      assert getType(value) is 'String' and value.match mongoId
    defaultArgs: ['userId', 'accountId', 'chatId', 'sessionId', 'websiteId', 'specialtyId']
  ,
    typeName: 'SessionId'
    validation: ({value}, assert) ->
      Session.findById value, (err, session) ->
        exists = not err and session?
        assert exists, {reason: 'Session does not exist'}
    lookup: ({sessionSecret}, found) ->
      Session.findOne {secret: sessionSecret}, {_id: 1}, (err, session) ->
        found err, session?._id

    defaultArgs: ['sessionId']
  ,
    typeName: 'SessionSecret'
    validation: ({value}, assert) ->
      Session.findOne {secret: value}, (err, session) ->
        exists = not err and session?
        assert exists, {reason: 'Session does not exist'}
    defaultArgs: ['sessionSecret']
  ,
    typeName: 'ChatId'
    validation: ({value}, assert) ->
      Chat.findById value, (err, chat) ->
        exists = not err and chat?
        assert exists, {reason: 'Chat does not exist'}
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

    # if law lookups accepted objects for found (i.e. a valid service signature),
    # then we could use the filters/lookupAccountId service
    lookup: ({sessionSecret, websiteId}, found) ->
      return found() unless sessionSecret or websiteId

      if sessionSecret
        Session.findOne {secret: sessionSecret}, {accountId: 1}, (err, session) ->
          found err, session?.accountId

      else if websiteId
        Website.findById websiteId, {accountId: 1}, (err, website) ->
          found err, website?.accountId

    defaultArgs: ['accountId']
  ,
    typeName: 'WebsiteImageName'
    validation: ({value}, assert) ->
      assert value in ['online', 'offline', 'logo']
    defaultArgs: ['imageName']
]
