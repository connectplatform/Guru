async = require 'async'
rest = require 'restler'
should = require 'should'
{inspect} = require 'util'
cache = config.require 'load/cache'

boiler 'REST - Chat Link Image', ->
  describe 'Chat link image', ->
    beforeEach ->
      testPort = @testPort
      websiteId = @website._id

      statusShouldBe = (status, cb) =>
        link = "http://localhost:#{testPort}/chatLinkImage/#{websiteId}"

        onComplete = (data, response) ->
          response.statusCode.should.eql 307, "Status: #{response.statusCode}. Response failed:\n#{response.rawEncoded}"
          response.headers.location.should.match new RegExp "#{websiteId}\/#{status}$"
          rest.get(link).removeListener 'complete', onComplete
          cb()
        rest.get(link).on 'complete', onComplete

      @expectOnline = (cb) -> statusShouldBe 'online', cb
      @expectOffline = (cb) -> statusShouldBe 'offline', cb

      cache.erase()


    it 'should display online image when operators are online', (done) ->
      @getAuthed =>
        @expectOnline done

    it 'should display offline image when operators are offline', (done) ->
      @expectOffline =>

        # set online/back offline
        @getAuthed =>
          @client.setSessionOffline {@sessionId}, (err) =>
            should.not.exist err

            @expectOffline done

    it 'should cache results', (done) ->
      async.series [
        @expectOffline
        @expectOffline
        @expectOffline
      ], (err) ->
        should.not.exist err
        done()
