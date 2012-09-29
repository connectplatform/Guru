async = require 'async'
should = require 'should'

boiler 'Service - showToValidOperators', ->

  beforeEach (done) ->
    self = @

    @showToValidOperators = config.require 'services/operator/showToValidOperators'

    @chats = [
        username: 'should show'
        params: {websiteUrl: 'foo.com'}
        department: 'Sales'
      ,
        username: 'should not show'
        params: {websiteUrl: 'baz.com'}
      ,
        username: 'should not show'
        params: {websiteUrl: 'foo.com'}
        department: 'Billing'
    ]

    async.map @chats, @newChatWith, (err, [chat]) =>
      @chatData =
        chatId: chat.id
        website: chat.params.websiteUrl
        specialty: chat.department
      done()

  describe 'with no operators', ->

    it 'should run', (done) ->
      @showToValidOperators @chatData, done

  describe 'with a valid operator', ->
    beforeEach (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, (err, @client) =>
        done()

    it 'should notify that operator', (done) ->
      session = @client.cookie 'session'

      myAlerts = @getPulsar().channel "notify:session:#{session}"
      myAlerts.on 'unansweredChats', ({count}) ->
        should.exist count, 'expected chat count'
        count.should.eql 1
        done()

      myAlerts.ready =>
        @showToValidOperators @chatData, (err, result) ->
          should.not.exist err
          should.exist result
