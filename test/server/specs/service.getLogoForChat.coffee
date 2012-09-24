should = require 'should'
querystring = require 'querystring'

boiler 'Service - Get Logo For Chat', ->

  it "should give you the logo url for a given chat's website", (done) ->
    chatData =
      username: 'aVisitor'
      referrerData:
        websiteUrl: 'http://www.example.com'

    @client = @getClient()
    @client.ready =>
      @client.newChat chatData, (err, chatId) =>
        should.not.exist err

        @client.getLogoForChat chatId, (err, url) =>
          should.not.exist err
          url.should.eql "http://#{config.app.aws.s3.bucket}.s3.amazonaws.com/#{querystring.stringify chatData.referrerData.websiteUrl}/logo"
          @client.disconnect()
          done()
