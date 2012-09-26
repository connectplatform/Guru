should = require 'should'

boiler 'Service - Get Logo For Chat', ->

  it "should give you the logo url for a given chat's website", (done) ->
    chatData =
      username: 'aVisitor'
      referrerData:
        websiteUrl: 'www.example.com'

    @client = @getClient()
    @client.ready =>
      @client.newChat chatData, (err, {channel}) =>
        should.not.exist err

        @client.getLogoForChat channel, (err, url) =>
          should.not.exist err
          url.should.eql "http://s3.amazonaws.com/#{config.app.aws.s3.bucket}/#{encodeURIComponent chatData.referrerData.websiteUrl}/logo"
          @client.disconnect()
          done()
