should = require 'should'

boiler 'Service - Get Online Operators', ->
  it "should return the names of all online operators", (done) ->
    @adminLogin (err, client) =>
      sessionId = client.cookie 'session'

      client.getOnlineOperators (err, operators) =>
        should.not.exist err
        operators.should.includeEql "Admin Guy"

        client.disconnect()
        done()
