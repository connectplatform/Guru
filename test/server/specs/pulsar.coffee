should = require 'should'
http = require 'http'
Pulsar = require 'pulsar'

port = 8092
serv = Pulsar.createServer http.createServer().listen port
client = Pulsar.createClient port: port

describe 'pulsar', ->

  it 'should send a server message', (done) ->
    schan = serv.channel 'test'
    cchan = client.channel 'test'

    cchan.on 'alert', (num) ->
      num.should.equal 2
      done()

    cchan.ready ->
      schan.emit 'alert', 2

  it 'should work', (done) ->
    schan = serv.channel 'test'
    cchan = client.channel 'test'

    should.exist schan
    should.exist cchan

    schan.on 'ping', (num) ->
      num.should.equal 2
      schan.emit 'pong', num

    cchan.on 'pong', (num) ->
      num.should.equal 2
      done()

    cchan.emit 'ping', 2
