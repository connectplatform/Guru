should = require 'should'
connect = require 'connect'
querystring = require 'querystring'
{setTimeout} = require 'timers'

db = config.require 'load/mongo'
{Session, Chat} = db.models

# query/form data
clientData = {
  username: 'Bob'
  customerId: '1'
  websiteUrl: 'foo.com'
}

# data ACP should respond with
expectedAcpData = {
  someField:
    firstSubfield: 'first subvalue'
    secondSubfield: 'another subvalue'
  anotherField: 'another value'
}

# set up rest endpoint for our mock ACP server
response = (req, res) ->
  query = querystring.parse req._parsedUrl.query
  if (query.customerId == clientData.customerId) && (query.websiteUrl == clientData.websiteUrl)
    res.end JSON.stringify expectedAcpData

boiler 'Service - Populate Visitor ACP Data', ->
  beforeEach (done) ->
    @ownerLogin (err, @owner) =>
      websiteFields =
        acpEndpoint: "http://localhost:8675"
        acpApiKey: "QWxhZGRpbjpvcGVuIHNlc2FtZQ=="

      @owner.findModel {queryObject: {url: 'foo.com'}, modelName: 'Website'}, (err, {data}) =>
        [target] = data
        @owner.saveModel {fields: target.merge(websiteFields), modelName: 'Website'}, done

  # note: this is not a service proper, but a subservice located in server/domain that is called by newChat
  it 'should hit the ACP server and dump data into Mongo', (done) ->
    testServer = connect().use(response).listen 8675 # process.env.GURU_PORT

    @client = @getClient()
    @client.ready =>

      # Set up chat info
      @client.newChat clientData, (err, {chatId, sessionId}) =>
        should.not.exist err

        console.log {chatId, sessionId, clientData}

        verifyResult = =>
          Chat.findById chatId, (err, chat) =>
            should.not.exist err
            should.exist chat
            console.log {chat}

            # chat
            
            done()
          # Session.accountLookup.get sessionId, (err, accountId) ->
          #   visitor = Chat(accountId).get(chatId).visitor
          #   visitor.get 'referrerData', (err, refData) ->
          #     should.not.exist err
          #     refData.should.include clientData

          #     visitor.get 'acpData', (err, acpData) ->
          #       should.not.exist err
          #       acpData.should.include expectedAcpData
          #       done()

        # The unfortunate part of making the acp lookup run async in the background...
        setTimeout verifyResult, 200
