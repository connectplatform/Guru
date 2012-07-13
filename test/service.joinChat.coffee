require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Join Chat', ->

  it 'should associate an operator with a chat', (done) ->
    visitorClient = @getClient()
    visitorClient.ready =>
      visitorClient.newChat {username: 'foo'}, (err, data) =>
        channel = visitorClient.cookie 'channel'
        visitorClient.disconnect()

        @getAuthed => 
          @client.joinChat channel, (err, data) =>
            false.should.eql err?
            id = @client.cookie('session')

            #TODO refactor this to check at a higher level than cache contents
            {OperatorChat} = redgoose.models
            OperatorChat.getChatsByOperator id, (err, data) =>

              false.should.eql err?
              data[channel].should.eql 'false'
              OperatorChat.getOperatorsByChat channel, (err, data) =>
                false.should.eql err?
                data[id].should.eql 'false'
                @client.disconnect()
                done()
