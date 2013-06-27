should = require 'should'
{User} = config.require('server/load/mongo').models
{Collector} = require 'particle'
superCache = config.require 'load/superCache'

boiler 'superCache', ->

  it 'with no data should return empty object', (done) ->
    superCache.get {key: 'sessionId', value: 123}, (err, lookups) ->
      should.not.exist err
      lookups.should.eql {}
      done()

  it 'should auto-update with sessionId -> accountId lookup', (done) ->
    @ownerLogin (err, client, {@sessionId}) =>
      superCache.get {key: 'sessionId', value: @sessionId, expected: 'accountId'}, (err, lookups) =>
        lookups.should.eql {accountId: @accountId}
        done()

  it 'should auto-update with chatId -> lookups', (done) ->
    Factory.create 'chat', (err, chat) =>
      should.not.exist err
      superCache.get {key: 'chatId', value: chat._id, expected: 'accountId'}, (err, lookups) =>
        lookups.should.eql {
          @accountId
          websiteId: chat.websiteId
          specialtyId: chat.specialtyId
        }
        done()

  it 'should auto-update with chatId -> relations', (done) ->
    @ownerLogin (err, client, {@sessionId}) =>
      Factory.create 'chat', (err, chat) =>
        Factory.create 'chatSession', {chatId: chat._id, sessionId: @sessionId}, (err, chatSession) =>

          superCache.get {key: 'chatId', value: chat._id, expected: 'sessionId'}, (err, lookups) =>
            lookups.should.eql {
              @accountId
              websiteId: chat.websiteId
              specialtyId: chat.specialtyId
              @sessionId
            }
            done()

  it 'should invalidate with removed relations', (done) ->
    @ownerLogin (err, client, {@sessionId}) =>
      Factory.create 'chat', (err, chat) =>
        Factory.create 'chatSession', {chatId: chat._id, sessionId: @sessionId}, (err, chatSession) =>
          superCache.get {key: 'chatId', value: chat._id, expected: 'sessionId'}, (err, lookups) =>
            lookups.should.eql {
              @accountId
              websiteId: chat.websiteId
              specialtyId: chat.specialtyId
              @sessionId
            }

            chatSession.remove (err) =>
              should.not.exist err

              # should no longer have sessionId relation
              finished = =>
                superCache.get {key: 'chatId', value: chat._id}, (err, lookups) =>
                  #@logger.grey 'lookups:'.cyan, lookups
                  lookups.should.eql {
                    @accountId
                    websiteId: chat.websiteId
                    specialtyId: chat.specialtyId
                  }
                  done()
              setTimeout finished, 100
