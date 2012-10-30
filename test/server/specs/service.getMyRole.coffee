should = require 'should'

boiler 'Service - Get My Role', ->
  describe 'when no session exists', ->
    beforeEach (done) ->
      @client = @getClient()
      @client.ready ->
        done()

    it "should say None", (done) ->
      @client.getMyRole {}, (err, role) ->
        role.should.eql 'None'
        done()

  describe 'when invalid session exists', ->
    beforeEach (done) ->
      @client = @getClient()
      @client.cookie 'session', 'bar'
      @client.ready ->
        done()

    it "should say None", (done) ->
      @client.getMyRole {}, (err, role) ->
        role.should.eql 'None'
        done()

  describe 'when Owner session exists', ->
    beforeEach (done) ->
      @ownerLogin (err, @client) =>
        done()

    it "should say Owner", (done) ->
      @client.getMyRole {}, (err, role) ->
        role.should.eql 'Owner'
        done()

  describe 'when Operator session exists', ->
    beforeEach (done) ->
      @guru1Login (err, @client) =>
        done()

    it "should say Operator", (done) ->
      @client.getMyRole {}, (err, role) ->
        role.should.eql 'Operator'
        done()

  describe 'when Visitor session exists', ->
    beforeEach (done) ->
      @guru1Login =>
        @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @client) =>
          done()

    it "should say Visitor", (done) ->
      should.exist @client.cookie 'session'
      @client.getMyRole {}, (err, role) ->
        role.should.eql 'Visitor'
        done()
