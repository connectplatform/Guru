should = require 'should'
connect = require 'connect'
querystring = require 'querystring'
{setTimeout} = require 'timers'
stoic = require 'stoic'

# data we got from referrer
referrerData = {
  customerId: '1'
  websiteUrl: 'www.example.com'
}

clientData = {
  username: 'aVisitor'
  referrerData: referrerData
}

# data server should respond with
expectedAcpData = {
  someField:
    firstSubfield: 'first subvalue'
    secondSubfield: 'another subvalue'
  anotherField: 'another value'
}

# set up rest endpoint for our mock ACP server
response = (req, res) ->
  query = querystring.parse req._parsedUrl.query
  if (query.customerId == referrerData.customerId) && (query.referrer == referrerData.referrer)
    res.end JSON.stringify expectedAcpData

boiler 'Service - Populate Visitor ACP Data', ->

  # note: this is not a service proper, but a subservice located in server/domain that is called by newChat
  it 'should hit the ACP server and dump data into redis', (done) ->
    testServer = connect().use(response).listen 8675

    @client = @getClient()
    @client.ready =>

      # Set up chat info
      @client.newChat clientData, (err, response) ->
        should.not.exist err

        chatId = response.channel

        # check that data is in stoic
        {Chat} = stoic.models

        verifyResult = ->
          visitor= Chat.get(chatId).visitor
          visitor.get 'referrerData', (err, refData) ->
            should.not.exist err
            refData.should.eql referrerData

            visitor.get 'acpData', (err, acpData) ->
              should.not.exist err
              acpData.should.eql expectedAcpData
              done()

        # The unfortunate part of making the acp lookup run async in the background...
        setTimeout verifyResult, 200
