should = require 'should'

boiler 'Service - Get Invites', ->
  beforeEach (done) ->
    @guru1Login (err, client1, params1) =>
      should.not.exist err
      should.exist client1
      should.exist params1
      @client1 = client1
      @params1 = params1
      @guru2Login (err, client2, params2) =>
        should.not.exist err
        should.exist client2
        should.exist params2
        @client2 = client2
        @params2 = params2
        @newChat (err, chat) =>
          should.not.exist err
          should.exist chat
          @client1.joinChat {@chatId}, (err) =>
            should.not.exist err
            @getInvites = config.require 'services/operator/getInvites'
            done()

  it 'should not get any invites if there are none', (done) ->
    @getInvites @params1.sessionId, (err, invites) =>
      should.not.exist err
      should.exist invites
      invites.should.be.empty
      done()
      
  it 'should get a ChatSession with relation `Invite`', (done) ->
    data =
      sessionId: @params1.sessionId
      targetSessionId: @params2.sessionId
      chatId: @chatId
    @client1.inviteOperator data, (err, chatSession) =>
      should.not.exist err
      should.exist chatSession
      chatSession.relation.should.equal 'Invite'
      
      # Check invites for guru2
      @getInvites @params2.sessionId, (err, invites) =>
        should.not.exist err
        should.exist invites
        invites.length.should.equal 1
        invite = invites[0]
        invite.sessionId.should.equal @params2.sessionId
        invite.chatId.should.equal @chatId
        invite.initiator.should.equal @params1.sessionId
        invite.relation.should.equal 'Invite'
        done()
    
  it 'should get a ChatSession  with relation `Transfer`', (done) ->
    data =
      sessionId: @params1.sessionId
      targetSessionId: @params2.sessionId
      chatId: @chatId
    @client1.transferChat data, (err, chatSession) =>
      should.not.exist err
      should.exist chatSession
      chatSession.relation.should.equal 'Transfer'

      # Check transfers for guru2
      @getInvites @params2.sessionId, (err, invites) =>
        should.not.exist err
        should.exist invites
        invites.length.should.equal 1
        invite = invites[0]
        invite.sessionId.should.equal @params2.sessionId
        invite.chatId.should.equal @chatId
        invite.initiator.should.equal @params1.sessionId
        invite.relation.should.equal 'Transfer'
        done()
    
  it 'should get two invites with distinct status', (done) ->
    @chatId1 = @chatId
    @newChat (err, chat) =>
      should.not.exist err
      should.exist chat
      @chatId2 = chat.chatId
      
      # Have guru1 Invite guru2 to chat1
      inviteData =
        sessionId: @params1.sessionId
        targetSessionId: @params2.sessionId
        chatId: @chatId1
      @client1.inviteOperator inviteData, (err, inviteChatSession) =>
        should.not.exist err
        should.exist inviteChatSession
        
        # Have guru2 request that guru1 transfer to chat2
        transferData =
          sessionId: @params2.sessionId
          targetSessionId: @params1.sessionId
          chatId: @chatId2
        @client2.transferChat transferData, (err, transferChatSession) =>
          should.not.exist err
          should.exist transferChatSession

          # guru2 should have an invite to chat1 from guru2
          @getInvites @params2.sessionId, (err, invites) =>
            should.not.exist err
            should.exist invites
            invites.length.should.equal 1

            invite = invites[0]
            invite.sessionId.should.equal inviteChatSession.sessionId
            invite.initiator.should.equal inviteChatSession.initiator
            invite.chatId.should.equal inviteChatSession.chatId
            invite.relation.should.equal 'Invite'
            
            # guru1 should have a transfer request to chat2 from guru1
            @getInvites @params1.sessionId, (err, invites) =>
              should.not.exist err
              should.exist invites
              invites.length.should.equal 1
              
              invite = invites[0]
              invite.sessionId.should.equal transferChatSession.sessionId
              invite.initiator.should.equal transferChatSession.initiator
              invite.chatId.should.equal transferChatSession.chatId
              invite.relation.should.equal 'Transfer'
                          
              done()
