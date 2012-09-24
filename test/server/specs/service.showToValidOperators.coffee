should = require 'should'

boiler 'Service - showToValidOperators', ->

  beforeEach (done) ->
    self = @

    @showToValidOperators = config.require 'services/operator/showToValidOperators'

    @createChats (err, [chat]) ->
      chat.visitor.getall (err, visitorData) ->
        self.chatData =
          chatId: chat.id
          website: visitorData.referrerData
          specialty: visitorData.specialty

        done()

  describe 'with no operators', ->

    it 'should run', (done) ->
      @showToValidOperators @chatData, done

  describe 'with a valid operator', ->
    beforeEach (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, done

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
