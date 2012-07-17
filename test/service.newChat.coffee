require 'should'
boiler = require './util/boilerplate'

boiler 'Service - New Chat', ->

  beforeEach ->
    data = {username: 'clientTest1'}
    @newChat = (done) =>
      @client.newChat data, (err, data) =>
        throw new Error err if err?
        @channel = @getPulsar().channel data.channel
        @session = @client.cookie 'session'
        done()

  it 'should let you interact with the server', (done) ->
    @newChat =>

      # establish listener
      @channel.on 'serverMessage', (data)->
        data.message.should.eql 'hello from the test'
        data.username.should.eql 'clientTest1'
        done()

      # build test data
      outgoing =
        session: @session
        message: 'hello from the test'

      # send test data
      @channel.emit 'clientMessage', outgoing

  it 'should notify operators of a new chat', (done) ->
    notify = @getPulsar().channel 'notify:operators'
    notify.on 'unansweredCount', (num) ->
      num.should.eql 1
      notify.removeAllListeners 'unansweredCount'
      done()

    if notify.events['unansweredCount']?
      @newChat()
    else
      notify.on 'newClient', =>
        @newChat()
