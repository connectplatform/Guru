should = require 'should'
{ChatSession} = config.require('load/mongo').models

boiler 'Service - Get Chat Membership', ->

  it "should get ids and chatRelation for chats I'm in", (done) ->
    @guru1Login (err, guru1, {sessionSecret, sessionId}) =>
      should.not.exist err

      Factory.create 'chatSession', {sessionId}, (err) =>
        should.not.exist err

        Factory.create 'chatSession', {sessionId}, (err) =>
          should.not.exist err

          config.services['operator/getChatMembership'] {sessionSecret, sessionId}, (err, {chatIds, chatRelation}) =>
            should.not.exist err
            should.exist chatIds?.length, 'expected chatIds'
            chatIds.length.should.eql 2

            should.exist chatRelation, 'expected chatRelation'
            chatRelation.keys().length.should.eql 2
            done()

  it "should return empty array for no chats", (done) ->
    @guru1Login (err, guru1, {sessionSecret, sessionId}) =>
      should.not.exist err

      config.services['operator/getChatMembership'] {sessionSecret, sessionId}, (err, {chatIds}) =>
        should.not.exist err
        should.exist chatIds?.length
        chatIds.length.should.eql 0
        done()
