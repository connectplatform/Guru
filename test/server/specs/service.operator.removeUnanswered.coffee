should = require 'should'

boiler 'Service - removeUnanswered', ->
  beforeEach (done) ->
    done

  it 'should remove a chat when it is there', (done) ->
    should.exist null
    done()

  it 'should not blow up when a chat is not there', (done) ->
    should.exist null
    done()
