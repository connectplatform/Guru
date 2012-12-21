should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Available Operators', ->

  beforeEach (done) ->
    @getAvailableOperators = config.service 'operator/getAvailableOperators'
    websiteFromDomain = config.service 'websites/getWebsiteIdForDomain'
    websiteFromDomain {websiteUrl: 'foo.com'}, (err, @fooSiteId) =>
      websiteFromDomain {websiteUrl: 'bar.com'}, (err, @barSiteId) =>
        done()

  describe 'with no operators', ->
    it 'should return no results', (done) ->
      @getAvailableOperators {websiteId: @fooSiteId, specialty: 'sales'}, (err, {accountId, operators}) ->
        should.not.exist err
        should.exist operators
        operators.length.should.eql 0
        done()

  describe 'with one owner', ->
    it 'should return one result', (done) ->
      @getAuthedWith {email: 'owner@foo.com', password: 'foobar'}, =>
        @getAvailableOperators {websiteId: @fooSiteId, specialty: 'Sales'}, (err, {accountId, operators}) ->
          should.not.exist err
          should.exist accountId
          should.exist operators
          operators.length.should.eql 1, 'Expected one operator.'
          done()

  describe 'with one operator', ->
    it 'should return one result', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators {websiteId: @fooSiteId, specialty: 'Sales'}, (err, {accountId, operators}) ->
          should.not.exist err
          should.exist accountId
          should.exist operators
          operators.length.should.eql 1, 'Expected one operator.'
          done()

  describe 'if website does not match', ->
    it 'should return no results', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators {websiteId: @barSiteId, specialty: 'Sales'}, (err, {accountId, operators}) ->
          should.not.exist err
          should.exist accountId
          should.exist operators
          operators.length.should.eql 0, 'Expected no operators.'
          done()
