async = require 'async'
should = require 'should'
redgoose = require 'redgoose'
boiler = require './util/boilerplate'

boiler 'Model - Operator Chat', ->

  it 'should associate an operator and chat', (done)->
    {OperatorChat} = redgoose.models

    async.series [

      # add and get chat/operator pairs
      OperatorChat.add 'operator', 'chat1', 'true'
      OperatorChat.add 'operator', 'chat2', 'false'
      OperatorChat.add 'operator2', 'chat2', 'true'
      OperatorChat.getChatsByOperator 'operator'
      OperatorChat.getOperatorsByChat 'chat2'

    ], (err, data) ->
      console.log 'got here'
      [_..., opChats, chatOps] = data
      console.log "err: #{err}" if err?
      false.should.eql err?

      # try to retrieve by operator
      opChats.chat1.should.eql 'true'
      opChats.chat2.should.eql 'false'

      # try to retrieve by chat
      chatOps.operator.should.eql 'false'
      chatOps.operator2.should.eql 'true'

      done()
