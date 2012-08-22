should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - New Chat', ->

  it 'should let you interact with the server', (done) ->
    @newChat =>
      @channel = @getPulsar().channel @chatChannelName
      # establish listener
      @channel.on 'serverMessage', (data)->
        data.message.should.eql 'hello from the test'
        done()

      # build test data
      outgoing =
        session: @visitorSession
        message: 'hello from the test'

      # send test data
      @channel.emit 'clientMessage', outgoing

  it 'should notify operators of a new chat', (done) ->
    notify = @getPulsar().channel 'notify:operators'
    notify.on 'unansweredCount', (num) ->
      num.should.eql 1
      notify.removeAllListeners 'unansweredCount'
      done()

    @newChat ->
