async = require 'async'
should = require 'should'
redgoose = require 'redgoose'
boiler = require './util/boilerplate'

boiler 'Model - Session Chat', ->

  it 'should associate an operator and chat', (done)->
    {SessionChat} = redgoose.models

    async.series [
      # add and get chat/operator pairs
      # the arguments would be IDs in a real case
      SessionChat.add 'operator1', 'chat1', isWatching: 'true'
      SessionChat.add 'operator1', 'chat2', isWatching: 'false'
      SessionChat.add 'operator2', 'chat2', isWatching: 'true'
      SessionChat.getChatsBySession 'operator1'
      SessionChat.getSessionsByChat 'chat2'

    ], (err, data) ->
      [_..., opChats, chatOps] = data
      console.log "err: #{err}" if err?
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
            true.should.eql relation.sessionId is 'operator1' or relation.sessionId is 'operator2'
            relation.isWatching.should.eql 'false' if relation.chatId is 'operator1'  
            relation.isWatching.should.eql 'true' if relation.chatId is 'operator2'  

          done()