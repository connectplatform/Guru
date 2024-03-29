rest = require 'restler'
should = require 'should'
{inspect} = require 'util'

boiler 'REST - Chat Link Image', ->
  describe 'Chat link image', ->

    beforeEach ->
      statusShouldBe = (status, cb) =>
        link = "http://localhost:#{@testPort}/chatLinkImage/#{@website._id}"
        rest.get(link).on 'complete', (data, response) =>
          response.statusCode.should.eql 307, "Status: #{response.statusCode}. Response failed:\n#{response.rawEncoded}"
          response.headers.location.should.match new RegExp "#{@website._id}\/#{status}$"
          cb()

      @expectOnline = (cb) -> statusShouldBe 'online', cb
      @expectOffline = (cb) -> statusShouldBe 'offline', cb

    it 'should display online image when operators are online', (done) ->
      @getAuthed =>
        @expectOnline done

    it 'should display offline image when operators are offline', (done) ->
      @expectOffline =>

        # set online/back offline
        @getAuthed =>
          @client.setSessionOffline {sessionId: @sessionId}, (err) =>
            should.not.exist err

            @expectOffline done

    it 'should cache results', (done) ->
      @timeout 40
      @expectOffline =>
        @expectOffline =>
          @expectOffline done
