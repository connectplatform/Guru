should = require 'should'

db = config.require 'load/mongo'
{Session} = db.models

boiler 'Service - Get Nonpresent Operators', ->
  beforeEach (done) ->
    @guru1Login (err, @guru1Client) =>
      should.not.exist err
      should.exist @guru1Client
      
      @guru2Login (err, @guru2Client) =>
        should.not.exist err
        should.exist @guru2Client

        @newChat =>
          done()
    
  it 'should return a list of operators not currently visible in chat', (done) ->
    @guru1Client.joinChat {@chatId}, (err) =>
      should.not.exist err

      @guru1Client.getNonpresentOperators {@chatId}, (err, {operators}) =>
        should.not.exist err
        should.exist operators

        operators.length.should.equal 1
        [op] = operators
        op.username.should.equal 'Second Guru'
              
        done()

  it 'should not return operators who are visible in the chat', (done) ->
    @guru1Client.joinChat {@chatId}, (err) =>
      should.not.exist err

      @guru2Client.joinChat {@chatId}, (err) =>
        should.not.exist err

        @guru1Client.getNonpresentOperators {@chatId}, (err, {operators}) =>
          should.not.exist err
          should.exist operators

          operators.length.should.equal 0
              
          done()
