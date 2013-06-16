rest = require 'restler'
should = require 'should'
{inspect} = require 'util'

counter = 0
getCounter = ->
  ++counter
valueOfCounter = -> counter

boiler 'REST - Chat Link Image', ->
  describe 'Chat link image', ->
    beforeEach ->
      testPort = @testPort
      websiteId = @website._id

      statusShouldBe = (status, cb) ->
        # console.log 'statusShouldBe:', status
        # link = "http://localhost:#{@testPort}/chatLinkImage/#{@website._id}"
        link = "http://localhost:#{testPort}/chatLinkImage/#{websiteId}"
        # requestCounter = getCounter()
        # console.log 'about to call rest.get, requestCounter is', requestCounter, valueOfCounter()
        rest.get(link).on 'complete', (data, response) ->
          # console.log 'got response for rest.get and requestCounter ==', requestCounter, valueOfCounter()
          response.statusCode.should.eql 307, "Status: #{response.statusCode}. Response failed:\n#{response.rawEncoded}"
          #response.headers.location.should.match new RegExp "#{@website._id}\/#{status}$"
          response.headers.location.should.match new RegExp "#{websiteId}\/#{status}$"
          # console.log 'about to call statusShouldBe callback...'
          cb()

      @expectOnline = (cb) -> statusShouldBe 'online', cb
      @expectOffline = (cb) -> statusShouldBe 'offline', cb

      @expectOffline1 = (cb) -> statusShouldBe 'offline', cb
      @expectOffline2 = (cb) -> statusShouldBe 'offline', cb
      @expectOffline3 = (cb) -> statusShouldBe 'offline', cb

      @makeExpectOffline = () -> ((cb) -> statusShouldBe 'offline', cb)

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
      myDone = () ->
        console.log 'CALLING MYDONE'.red
        done()
      @timeout 800
      # original
      # console.log 'DEBUG', 1
      # @expectOffline =>
      #   console.log 'DEBUG', 2
      #   @expectOffline =>
      #     console.log 'DEBUG', 3
      #     @expectOffline done
      #
      # 
      async = require 'async'
      async.series [
        @expectOffline
        @expectOffline
      ], (err) ->
        should.not.exist err
        myDone()

      # @expectOffline =>
      #   console.log 'DEBUG', 2
      # @expectOffline =>
      #     console.log 'DEBUG', 3
      # @expectOffline done
