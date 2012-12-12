rest = require 'restler'
should = require 'should'
{inspect} = require 'util'

boiler 'REST - Chat Link Image', ->
  describe 'Chat link image', ->

    it 'should print a chat history', (done) ->
      Factory.create 'chathistory', (err, history) =>
        @getAuthed =>
          sessionId = @client.cookie 'session'

          url = "http://localhost:#{@testPort}/printChatArchive?chatname=sum%20gai"
          options =
            headers:
              Cookie: "session=#{sessionId}"

          rest.get(url, options).on 'complete', (data, response) =>
            response.statusCode.should.eql 200, "Status: #{response.status}. Response failed:\n#{response.rawEncoded}"
            data.should.include history.visitor.username
            data.should.include history.visitor.websiteUrl
            data.should.include history.history[0].message
            done()
