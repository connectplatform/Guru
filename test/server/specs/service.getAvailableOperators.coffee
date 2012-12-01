should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Available Operators', ->

  beforeEach (done) ->
    @getAvailableOperators = config.service 'operator/getAvailableOperators'
    websiteFromDomain = config.service 'websites/getWebsiteIdForDomain'
    websiteFromDomain {domain: 'foo.com'}, (err, @fooSiteId) =>
      websiteFromDomain {domain: 'bar.com'}, (err, @barSiteId) =>
        done()

  describe 'without specifying a specialty, with 2 operators', ->
    it 'should return two online departments', (done) ->

      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAuthedWith {email: 'guru2@foo.com', password: 'foobar'}, =>

          @getAvailableOperators {websiteId: @fooSiteId}, (err, data) ->
            should.not.exist err
            data.onlineDepartments.indexOf('Billing').should.not.equal -1
            data.onlineDepartments.indexOf('Sales').should.not.equal -1
            done()

  describe 'with no operators', ->
    it 'should return no results', (done) ->
      @getAvailableOperators {websiteId: @fooSiteId, specialty: 'sales'}, (err, {accountId, operators}) ->
        should.not.exist err
        should.exist operators
        operators.length.should.eql 0
        done()

    it 'should return an empty "onlineDepartments" array', (done) ->
      @getAvailableOperators {websiteId: @fooSiteId}, (err, data) ->
        should.not.exist err
        data.onlineDepartments.length.should.equal 0
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
