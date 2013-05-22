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
      @getAvailableOperators {websiteId: @fooSiteId, specialtyName: 'sales'}, (err, {accountId, operators}) ->
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
