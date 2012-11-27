should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Available Operators', ->

  beforeEach (done) ->
    @getAvailableOperators = config.require 'services/operator/getAvailableOperators'
    websiteFromDomain = config.service 'websites/getWebsiteIdForDomain'
    websiteFromDomain {domain: 'foo.com'}, (err, @fooSiteId) =>
      websiteFromDomain {domain: 'bar.com'}, (err, @barSiteId) =>
        done()

  describe 'with no operators', ->
    it 'should return no results', (done) ->
      @getAvailableOperators @fooSiteId, 'sales', (err, accountId, ops) ->
        should.not.exist err
        should.exist ops
        ops.length.should.eql 0
        done()

  describe 'with one operator', ->
    it 'should return one result', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators @fooSiteId, 'Sales', (err, accountId, ops) ->
          should.not.exist err
          should.exist accountId
          should.exist ops
          ops.length.should.eql 1, 'Expected one operator.'
          done()

  describe 'if website does not match', ->
    it 'should return no results', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators @barSiteId, 'Sales', (err, accountId, ops) ->
          should.not.exist err
          should.exist accountId
          should.exist ops
          ops.length.should.eql 0, 'Expected no operators.'
          done()
