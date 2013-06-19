should = require 'should'
{ChatSession} = config.require('load/mongo').models

boiler 'Service - Get Chat Membership', ->

  it "should get ids for chats I'm in", (done) ->
    @guru1Login (err, guru1, {sessionSecret, sessionId}) =>
      should.not.exist err

      Factory.create 'chatSession', {sessionId}, (err) =>
        should.not.exist err

        Factory.create 'chatSession', {sessionId}, (err) =>
          should.not.exist err

          config.services['operator/getChatMembership'] {sessionSecret, sessionId}, (err, {chatIds}) =>
            should.not.exist err
            should.exist chatIds?.length
            chatIds.length.should.eql 2
            done()

  it "should return empty array for no chats", (done) ->
    @guru1Login (err, guru1, {sessionSecret, sessionId}) =>
      should.not.exist err

      config.services['operator/getChatMembership'] {sessionSecret, sessionId}, (err, {chatIds}) =>
        should.not.exist err
        should.exist chatIds?.length
        chatIds.length.should.eql 0
        done()
