should = require 'should'

boiler 'Service - New Chat', ->

  it 'should let you chat', (done) ->
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
    @getAuthed =>
      session = @client.cookie 'session'
      notify = @getPulsar().channel "notify:session:#{session}"
      notify.on 'unansweredChats', ({count}) ->
        count.should.eql 1
        notify.removeAllListeners 'unansweredChats'
        done()

      @newChat ->
