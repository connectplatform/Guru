should = require 'should'

boiler 'Service - Get Available Operators', ->

  beforeEach (done) ->
    @getAvailableOperators = config.service 'operator/getAvailableOperators'
    websiteFromDomain = config.service 'websites/getWebsiteIdForDomain'
    websiteFromDomain {websiteUrl: 'foo.com'}, (err, {websiteId}) =>
      should.exist websiteId
      @fooSiteId = websiteId
      websiteFromDomain {websiteUrl: 'bar.com'}, (err, {websiteId}) =>
        @barSiteId = websiteId
        done()

  describe 'with no operators', ->
    it 'should return no results', (done) ->
      @getAvailableOperators {websiteId: @fooSiteId, specialtyName: 'Sales'}, (err, {accountId, operators}) ->
        should.not.exist err
        should.exist operators
        operators.length.should.eql 0
        done()

  describe 'with one owner', ->
    it 'should return one result', (done) ->
      @getAuthedWith {email: 'owner@foo.com', password: 'foobar'}, =>
        @getAvailableOperators {websiteId: @fooSiteId, specialtyName: 'Sales'}, (err, {accountId, operators}) ->
          should.not.exist err
          should.exist accountId
          should.exist operators
          operators.length.should.eql 1, 'Expected one operator.'
          done()

  describe 'with one operator', ->
    it 'should return one result', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators {websiteId: @fooSiteId, specialtyName: 'Sales'}, (err, {accountId, operators}) ->
          should.not.exist err
          should.exist accountId
          should.exist operators
          operators.length.should.eql 1, 'Expected one operator.'
          done()

  describe 'if website does not match', ->
    it 'should return no results', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators {websiteId: @barSiteId, specialtyName: 'Sales'}, (err, {accountId, operators}) ->
          should.not.exist err
          should.exist accountId
          should.exist operators
          operators.length.should.eql 0, 'Expected no operators.'
          done()

  describe 'if two operators have sessions but one has status online == false', ->
    it 'should only show the operator who has status online == true', (done) ->
      {Session} = config.require('load/mongo').models
      @guru1Login (err, @guru1, {sessionId}) =>
        guru1SessionId = sessionId
        Session.findById guru1SessionId, (err, session1) =>
          should.not.exist err
          should.exist session1, 'session1 should exist'
          session1.online.should.equal true
          
          @guru2Login (err, @guru2, {sessionId}) =>
            guru2SessionId = sessionId
            Session.findById guru2SessionId, (err, session2) =>
              should.not.exist err
              should.exist session2

              session2.online = false
              session2.save (err) =>
                should.not.exist err
                
                @getAvailableOperators {websiteId: @fooSiteId}, (err, {accountId, operators}) =>
                  [op] = operators
                  should.exist op
                  op._id.should.equal session1.userId
                  done()