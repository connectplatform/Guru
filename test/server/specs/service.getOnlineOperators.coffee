should = require 'should'

boiler 'Service - Get Online Operators', ->
  it "should return the names of one online operator", (done) ->
    @guru1Login (err, client) =>
      should.not.exist err
      should.exist client
      client.getOnlineOperators {}, (err, {operatorNames}) =>
        should.not.exist err
        should.exist operatorNames
        operatorNames.length.should.equal 1
        operatorNames.should.includeEql "First Guru"
        done()

  it "should return the names of two online operators", (done) ->
    @guru1Login (err, client) =>
      should.not.exist err
      should.exist client
      @guru2Login (err, client) =>
        should.not.exist err
        should.exist client
        client.getOnlineOperators {}, (err, {operatorNames}) =>
          should.not.exist err
          should.exist operatorNames
          operatorNames.length.should.equal 2
          operatorNames.should.includeEql "First Guru"
          operatorNames.should.includeEql "Second Guru"
          done()
