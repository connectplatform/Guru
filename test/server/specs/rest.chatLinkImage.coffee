rest = require 'restler'
should = require 'should'

boiler 'REST - Chat Link Image', ->
  describe 'Chat link image', ->
    before ->
      statusShouldBe = (status,  cb) =>
        rest.get("http://localhost:#{@testPort}/example.com/chatLinkImage").on '3XX', (data, response) =>
          response.statusCode.should.eql 307
          new RegExp("example.com\/#{status}$").test(response.headers.location).should.eql true
          cb()

      @expectOnline = (cb) -> statusShouldBe 'online', cb
      @expectOffline = (cb) -> statusShouldBe 'offline', cb

    it 'should redirect you based on whether operators are online', (done) ->
      @expectOffline =>

        @getAuthed =>
          sessionId = @client.cookie 'session'

          @expectOnline =>

            @client.setSessionOffline @client.cookie('session'), (err) =>
              should.not.exist err
              @expectOffline =>

                @client.disconnect()
                done()
