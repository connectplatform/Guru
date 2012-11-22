should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Recurly Token', ->

  beforeEach (done) ->
    createRecurlyAccount = config.service 'account/createRecurlyAccount'
    @accountId = @account._id.toString()

    createRecurlyAccount {accountId: @accountId, owner: @ownerUser}, done

  it 'should retrieve a token', (done) ->
    @getAuthed =>
      @client.getRecurlyToken {accountId: @accountId}, (err, data) ->
        should.not.exist err
        should.exist data?.token
        done()
