should = require 'should'
async = require 'async'

boiler 'Service - Get Chat Archive', ->

  it 'should retrieve the archive of a chat', (done) ->
    Factory.create 'chathistory', (err, history) =>
      @getAuthed =>
        @client.getChatArchive {accountId: @account._id, search: {'visitor.username': 'sum gai'}}, (err, archive) ->
          should.not.exist err
          should.exist archive
          archive.length.should.eql 2
          archive[0].visitor.username.should.eql 'sum gai'
          archive[0].history.length.should.eql 2
          archive[0].operators.length.should.eql 1
          done()
