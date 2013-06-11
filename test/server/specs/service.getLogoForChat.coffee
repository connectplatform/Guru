should = require 'should'

db = config.require 'load/mongo'
{Chat} = db.models

boiler 'Service - Get Logo For Chat', ->

  it "should give you the logo url for a given chat's website", (done) ->
    chatData =
      username: 'aVisitor'
      websiteUrl: 'foo.com'

    @getAuthed (_..., {accountId}) =>
      @newVisitor chatData, (err) =>
        should.not.exist err
        should.exist @chatId, 'expected chatId'

        @client.getLogoForChat {chatId: @chatId}, (err, {url}) =>
          should.not.exist err
          should.exist url

          Chat.findById @chatId, (err, chat) =>
            should.not.exist err
            should.exist chat
            {websiteId} = chat
            url.should.eql "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{websiteId}/logo"
            done()
