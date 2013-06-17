should = require 'should'

boiler 'Service - Get My Role', ->
  describe 'when no session exists', ->
    beforeEach (done) ->
      @client = @getClient()
      @client.ready ->
        done()

    it "should say None", (done) ->
      @client.getMyRole {}, (err, {role}) ->
        should.not.exist err
        role.should.eql 'None'
        done()

  describe 'when invalid session exists should say None', ->
    beforeEach (done) ->
      @getClient (err, @client) =>
        @client.getMyRole {sessionId: 'bar'}, (err, {role}) ->
          should.not.exist err
          role.should.eql 'None'
          done()

  describe 'when Owner session exists', ->
    beforeEach (done) ->
      @ownerLogin (err, @client) =>
        should.not.exist err
        done()

    it "should say Owner", (done) ->
      @client.getMyRole {}, (err, {role}) ->
        should.not.exist err
        role.should.eql 'Owner'
        done()

  describe 'when Operator session exists', ->
    beforeEach (done) ->
      @guru1Login (err, @client) =>
        should.not.exist err
        done()

    it "should say Operator", (done) ->
      @client.getMyRole {}, (err, {role}) ->
        should.not.exist err
        role.should.eql 'Operator'
        done()

  describe 'when Visitor session exists', ->
    beforeEach (done) ->
      @guru1Login (err, @guru) =>
        should.not.exist err
        
        @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @client) =>
          should.not.exist err
          done()

    it "should say Visitor", (done) ->
      should.exist @visitorSession
      @client.getMyRole {}, (err, {role}) ->
        should.not.exist err
        role.should.eql 'Visitor'
        done()
