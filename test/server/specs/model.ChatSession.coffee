should = require 'should'
db = config.require 'server/load/mongo'
{Account, Chat, ChatSession, Session, User, Website} = db.models
{chatStatusStates} = config.require 'load/enums'


boiler 'Model - ChatSession', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      should.not.exist err
      should.exist account
      
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        should.not.exist err
        @userId = user._id
        Website.findOne {accountId: @accountId}, (err, website) =>
          should.not.exist err
          should.exist website
          @websiteId = website._id
          @websiteUrl = website.url
          chatData =
            status: 'Vacant'
            accountId: @accountId
            websiteId: @websiteId
            websiteUrl: @websiteUrl
            formData:
              username: 'Visitor'
          Factory.create 'chat', chatData, (err, chat) =>
            should.not.exist err
            @chatId = chat._id
            sessionData =
              accountId: @accountId
            Factory.create 'session', sessionData, (err, session) =>
              should.not.exist err
              should.exist session
              should.not.exist session.userId
              @sessionId = session._id
              done err

  it 'should let you create a valid ChatSession', (done) ->
    Factory.create 'chatSession', {@sessionId, @chatId}, (err, chatSession) =>
      should.not.exist err
      should.exist chatSession
      chatSession.sessionId.toString().should.equal @sessionId
      chatSession.chatId.toString().should.equal @chatId
      chatSession.relation.should.equal 'Member'
      done()

  it 'should not let you create a ChatSession without all data', (done) ->
    data =
      relation: null
      sessionId: @sessionId
      chatId: @chatId

    Factory.create 'chatSession', data, (err, chatSession) =>
      should.exist err
      expectedErrMsg = 'Validator "enum" failed for path relation with value `null`'
      err.errors.relation.message.should.equal expectedErrMsg
      done()

  describe 'ChatSession post event hooks', ->
    beforeEach (done) ->
      @chatStatusIs = (status, next) =>
        Chat.findById @chatId, (err, chat) =>
          should.not.exist err
          should.exist chat
          if chat.status is status
            next()
          else
            # This is a hack to account for MongoDb's eventual consistency
            console.log "Checking Chat.status again, expecting #{status}"
            @chatStatusIs status, next
          # chat.status.should.equal status
          # next()
      done()
      
    it 'should update Chat status when a ChatSession is created', (done) ->
      # We should start out Vacant
      @chatStatusIs 'Vacant', () =>

        # We will create a ChatSession with a Visitor...
        Factory.create 'chatSession', {@sessionId, @chatId, relation: 'Visitor'}, (err, chatSession) =>
          should.not.exist err
          should.exist chatSession
          
          # ...so now the Chat status should be Waiting
          @chatStatusIs 'Waiting', () =>
            @guru1Login (err, @guru1) =>
              should.not.exist err
              should.exist @guru1

              # Now an Operator joins the Chat...
              @guru1.joinChat {@chatId}, (err) =>
                should.not.exist err
                
                # So the status should become Active
                @chatStatusIs 'Active', () =>
                  done()

    it 'should update Chat status when a ChatSession is saved', (done) ->
      # We should start out Vacant
      @chatStatusIs 'Vacant', () =>

        # We will create a ChatSession with a Visitor...
        Factory.create 'chatSession', {@sessionId, @chatId, relation: 'Visitor'}, (err, chatSession) =>
          should.not.exist err
          should.exist chatSession
          
          # ...so now the Chat status should be Waiting
          @chatStatusIs 'Waiting', () =>
            @guru1Login (err, @guru1) =>
              should.not.exist err
              should.exist @guru1

              # Now an Operator watches the Chat...
              @guru1.watchChat {@chatId}, (err) =>
                should.not.exist err
                
                # So the status should still be Waiting, since the Operator is invisible
                @chatStatusIs 'Waiting', () =>

                  # But now he'll change his relation from Watching to Member
                  @guru1.joinChat {@chatId}, (err) =>
                    should.not.exist err

                    # So the status should become Active
                    @chatStatusIs 'Active', () =>
                      done()

    
    it 'should update Chat status when a ChatSession is removed', (done) ->
      # We should start out Vacant
      @chatStatusIs 'Vacant', () =>

        # We will create a ChatSession with a Visitor...
        Factory.create 'chatSession', {@sessionId, @chatId, relation: 'Visitor'}, (err, chatSession) =>
          should.not.exist err
          should.exist chatSession
          
          # ...so now the Chat status should be Waiting
          @chatStatusIs 'Waiting', () =>
            @guru1Login (err, @guru1) =>
              should.not.exist err
              should.exist @guru1

              # Now an Operator joins the Chat...
              @guru1.joinChat {@chatId}, (err) =>
                should.not.exist err
                
                # So the status should become Active
                @chatStatusIs 'Active', () =>

                  # But when he leaves
                  @guru1.leaveChat {@chatId}, (err) =>
                    should.not.exist err

                    # It should become Waiting again
                    @chatStatusIs 'Waiting', () =>
                      done()