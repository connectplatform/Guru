should = require 'should'

boiler 'Service - Get Invites', ->
  beforeEach (done) ->
    @guru1Login (err, client1, params1) =>
      @client1 = client1
      @params1 = params1
      @guru2Login (err, client2, params2) =>
        @client2 = client2
        @params2 = params2
        @newChat (err, chat) =>
          @chat = chat
          @getInvites = config.require 'services/operator/getInvites'
          done()

  it 'should not get any invites if there are none', (done) ->
    @getInvites @params1.sessionId, (err, invites) =>
      should.not.exist err
      should.exist invites
      invites.should.be.empty
      done()
      
  it 'should get an invite with status `Invite`', (done) ->
    should.exist null
    done()
    
  it 'should get an invite with status `Transfer`', (done) ->
    should.exist null
    done()
    
  it 'should get two invites with distinct status', (done) ->
    should.exist null
    done()
    