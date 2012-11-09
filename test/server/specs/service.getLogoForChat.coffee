should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Logo For Chat', ->

  it "should give you the logo url for a given chat's website", (done) ->
    chatData =
      username: 'aVisitor'
      websiteUrl: 'foo.com'

    @getAuthed (_..., accountId) =>
      @client = @getClient()
      @client.ready =>
        @client.newChat chatData, (err, {chatId}) =>
          should.not.exist err

          @client.getLogoForChat {chatId: chatId}, (err, url) =>
            should.not.exist err

            {Chat} = stoic.models
            Chat(accountId).get(chatId).websiteId.get (err, websiteId) =>
              should.not.exist err
              url.should.eql "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{websiteId}/logo"
              @client.disconnect()
              done()
