should = require 'should'

boiler 'Service - Get Online Operators', ->
  it "should return the names of all online operators", (done) ->
    client = @getClient()
    client.ready =>

      client.getOnlineOperators (err, operators) =>
        should.not.exist err
        operators.length.should.eql 0
        client.disconnect()

        @adminLogin (err, client2) =>
          sessionId = client2.cookie 'session'

          client2.getOnlineOperators (err, operators) =>
            should.not.exist err
            operators.should.includeEql "Admin Guy"

            client2.setSessionOffline client2.cookie('session'), (err) =>
              should.not.exist err

              client2.getOnlineOperators (err, operators) =>
                should.not.exist err
                operators.length.should.eql 0

                client2.disconnect()
                done()
