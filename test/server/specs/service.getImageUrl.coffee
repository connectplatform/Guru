should = require 'should'

boiler 'Service - Get Image Url', ->

  it 'with website should return specific link', (done) ->
    @getClient (@client) =>
      @client.getImageUrl {websiteUrl: 'foo.com', imageName: 'logo'}, (err, {url}) ->
        should.not.exist err
        should.exist url
        url.should.match new RegExp 'https://s3.amazonaws.com/guru-dev/website/.+/logo'
        done()

  it 'with no website should return default link', (done) ->
    @getClient (@client) =>
      @client.getImageUrl {imageName: 'logo'}, (err, {url}) ->
        should.not.exist err
        should.exist url
        url.should.eql 'https://s3.amazonaws.com/guru-dev/website/default/logo'
        done()
