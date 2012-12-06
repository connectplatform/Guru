should = require 'should'
{inspect} = require 'util'

boiler 'Service - Create Chat or Get Form', ->
  beforeEach (done) ->
    @client = @getClient()
    @client.ready =>
      @ownerLogin =>
        done()

  describe 'with sufficient paramaters', ->
    before ->
      @params =
        websiteUrl: 'foo.com'
        department: 'Sales'
        username: 'George'

    it 'should create a chat', (done) ->
      @client.createChatOrGetForm @params, (err, data) =>
        should.not.exist err
        should.exist data?.chatId

        session = @client.cookie 'session'
        should.exist session, 'expected session cookie'
        done()

  describe 'with no username', ->
    before ->
      @params =
        websiteUrl: 'foo.com'
        department: 'Sales'

    it 'should request form data', (done) ->
      @client.createChatOrGetForm @params, (err, data) =>
        should.not.exist err
        should.exist data?.fields
        data.fields[0].name.should.eql 'username'
        done()

  describe 'with no department', ->
    before ->
      @params =
        websiteUrl: 'foo.com'
        username: 'George'

    it 'should request form data', (done) ->
      @client.createChatOrGetForm @params, (err, data) =>
        should.not.exist err
        should.exist data?.fields, "expected data.fields:\n#{inspect data}"
        data.fields[0].name.should.eql 'department'
        data.fields[0].selections.map('label').should.include 'Sales (chat)'
        done()

  describe 'with no website', ->
    it 'should request form data', (done) ->
      @client.createChatOrGetForm {}, (err, data) =>
        should.exist err
        err.should.eql 'Could not route chat due to missing website.'
        #should.exist data?.fields
        #data.fields[0].name.should.eql 'websiteUrl'
        done()
