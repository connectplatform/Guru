async = require 'async'
should = require 'should'
stoic = require 'stoic'

boiler 'Model - Chat Session', ->
  it 'should associate an operator and chat', (done)->
    {ChatSession, Chat, Session} = stoic.models
    cs = ChatSession('ab1234567890ab1234567890')
    c = Chat('ab1234567890ab1234567890')
    s = Session('ab1234567890ab1234567890')

    async.parallel {
      chat1: c.create
      chat2: c.create
      op1: s.create {role: 'Operator', operatorId: 1, chatName: "op1"}
      op2: s.create {role: 'Operator', operatorId: 2, chatName: "op2"}

    }, (err, {chat1, chat2, op1, op2}) ->
      should.not.exist err

      async.parallel [
        # add and get chat/operator pairs
        # the arguments would be IDs in a real case
        cs.add op1.id, chat1.id, isWatching: 'true'
        cs.add op1.id, chat2.id, isWatching: 'false'
        cs.add op2.id, chat2.id, isWatching: 'true'

      ], (err) ->
        should.not.exist err

        async.parallel {
          opChats: cs.getBySession '000000operator01'
          chatOps: cs.getByChat 'chat2'
        }, (err, {opChats, chatOps}) ->
          should.not.exist err

          getIsWatching = (relation, cb) ->
            relation.relationMeta.get 'isWatching', (err, isWatching) ->
              relation.isWatching = isWatching
              cb err, relation

          # try to retrieve by operator
          async.map opChats, getIsWatching, (err, relations) ->
            should.not.exist err
            for relation in relations
              true.should.eql (relation.chatId is 'chat1' or relation.chatId is 'chat2')
              relation.isWatching.should.eql 'true' if relation.chatId is 'chat1'
              relation.isWatching.should.eql 'false' if relation.chatId is 'chat2'

            # try to retrieve by chat
            async.map chatOps, getIsWatching, (err, relations) ->
              should.not.exist err
              for relation in relations
                true.should.eql relation.sessionId is '000000operator01' or relation.sessionId is '000000operator02'
                relation.isWatching.should.eql 'false' if relation.chatId is '000000operator01'
                relation.isWatching.should.eql 'true' if relation.chatId is '000000operator02'

              done()
