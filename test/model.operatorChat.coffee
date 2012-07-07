require 'should'
redgoose = require 'redgoose'
boiler = require './util/boilerplate'

boiler 'Model - Operator Chat', ->

  it 'should associate an operator and chat', (done)->
    {OperatorChat} = redgoose.models

    #add chat/operator pairs
    OperatorChat.add 'operator', 'chat1', 'true', (err, data)->
      false.should.eql err?
      OperatorChat.add 'operator', 'chat2', 'false', (err, data) ->
        console.log "err: #{err}" if err?
        false.should.eql err?
        OperatorChat.add 'operator2', 'chat2', 'true', (err, data) ->
          console.log "err: #{err}" if err?
          false.should.eql err?

          #try to retrieve by operator
          OperatorChat.getChatsByOperator 'operator', (err, data) ->
            console.log "err: #{err}" if err?
            false.should.eql err?

            data.chat1.should.eql 'true'
            data.chat2.should.eql 'false'

            #try to retrieve by chat
            OperatorChat.getOperatorsByChat 'chat2', (err, data) ->
              false.should.eql err?

              data.operator.should.eql 'false'
              data.operator2.should.eql 'true'

              done()