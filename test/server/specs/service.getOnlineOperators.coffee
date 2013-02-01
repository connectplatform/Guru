should = require 'should'

boiler 'Service - Get Online Operators', ->
  it "should return the names of all online operators", (done) ->
    @ownerLogin (err, client) =>

      client.getOnlineOperators {}, (err, {operatorNames}) =>
        should.not.exist err
        operatorNames.should.includeEql "Owner Man"
        done()
