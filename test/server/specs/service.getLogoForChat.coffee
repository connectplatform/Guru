should = require 'should'

boiler 'Service - Get Logo For Chat', ->

  it "should give you the logo url for a given chat's website", (done) ->
    chatData =
      username: 'aVisitor'
      websiteUrl: 'www.foo.com'

    @client = @getClient()
    @client.ready =>
      @client.newChat chatData, (err, {chatId}) =>
        should.not.exist err

        @client.getLogoForChat chatId, (err, url) =>
          should.not.exist err
          url.should.eql "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{encodeURIComponent chatData.websiteUrl}/logo"
          @client.disconnect()
          done()
