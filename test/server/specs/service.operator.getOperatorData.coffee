should = require 'should'
db = config.require 'load/mongo'
{Session, User} = db.models

boiler 'Service - getOperatorData', ->
  beforeEach ->
    @getOperatorData = config.services['operator/getOperatorData']
    
  it 'should give you the right User data', (done) ->
    @ownerLogin (err, client, {sessionId}) =>
      should.not.exist err
      should.exist client

      Session.findById sessionId, (err, session) =>
        should.not.exist err
        should.exist session
        
        {userId} = session
        User.findById userId, (err, user) =>
          should.not.exist err
          should.exist user
          
          @getOperatorData {sessionId}, (err, operator) =>
            should.not.exist err
            should.exist operator
            
            operator._id.should.equal user._id
            done()
