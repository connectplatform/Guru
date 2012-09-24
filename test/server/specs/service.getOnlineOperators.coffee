should = require 'should'

boiler 'Service - Get Online Operators', ->
  it "should return the names of all online operators", (done) ->
    @client = @getClient()
    @client.ready =>

      @client.getOnlineOperators (err, operators) =>
        should.not.exist err
        operators.length.should.eql 0

        @client.login @adminLogin, (err) =>
          sessionId = @client.cookie 'session'

          @client.getOnlineOperators (err, operators) =>
            should.not.exist err
            operators.should.includeEql "Admin Guy"
          
            @client.setSessionOffline @client.cookie('session'), (err) =>
              should.not.exist err

              @client.getOnlineOperators (err, operators) =>
                should.not.exist err
                operators.length.should.eql 0

                @client.disconnect()
                done()
