db = config.require 'server/load/mongo'
stoic = require 'stoic'
async = require 'async'
should = require 'should'

Vein = require 'vein'
Pulsar = require 'pulsar'

testPort = process.env.GURU_PORT
pulsarPort = process.env.GURU_PULSAR_PORT

#Exported object of helper functions
helpers =
  getClient: (receive) ->
    client = Vein.createClient port: testPort
    if receive
      client.ready ->
        receive client
    else
      return client

  getPulsar: -> Pulsar.createClient port: pulsarPort
  testPort: testPort

  loginBuilder: (name) ->
    (cb) =>
      data =
        email: "#{name}@foo.com"
        password: 'foobar'
      @getAuthedWith data, cb

  getAuthedWith: (data, cb) ->
    {Session} = stoic.models
    client = @getClient()
    client.ready =>
      client.login data, (err, {sessionId}) =>
        console.log 'error on test login:', err if err or not sessionId
        Session.accountLookup.get sessionId, (_, accountId) ->
          cb err, client, {sessionId: sessionId, accountId: accountId}

  # to be backwards compatible.  maybe refactor old tests?
  getAuthed: (cb) ->
    @ownerLogin (err, @client, vars) =>
      {@accountId, @sessionId} = vars
      cb err, @client, vars

  # create a chat and hang onto visitor client
  newVisitor: (data, cb) ->
    {Specialty} = db.models
    visitor = @getClient()
    visitor.ready =>
      Specialty.findOne {accountId: @account._id, name: data.department}, (err, specialty) =>
        data.department = specialty?._id
        visitor.newChat data, (err, data) =>
          throw new Error err if err
          @visitorSession = visitor.cookie 'session'
          @chatId = data.chatId
          cb null, visitor, data

  # create a chat but disconnect the visitor when done
  newChatWith: (data, cb) ->
    @newVisitor data, (err, visitor, chatData) ->
      visitor.disconnect()
      cb err, Object.merge data, {data: chatData}

  # shorthand for default use case
  newChat: (cb) ->
    @newChatWith {username: 'visitor', websiteUrl: 'foo.com'}, cb

  expectSessionIsOnline: (sessionId, expectation, cb) ->
    {Session} = stoic.models
    Session.accountLookup.get sessionId, (err, accountId) ->
      Session(accountId).get(sessionId).online.get (err, online) =>
        should.not.exist err
        online.should.eql expectation
        cb()

  loginOperator: (cb) ->
    @guru1Login (err, client) =>
      throw new Error err if err
      @targetSession = client.cookie 'session'
      cb null, client

  createChats: (cb) ->
    {Chat} = stoic.models
    now = Date.create().getTime()

    {Account, Website} = db.models

    websiteUrl = 'foo.com'
    Website.findOne {url: websiteUrl}, {_id: true}, (err, website) ->
      throw new Error "Could not find website [#{websiteUrl}]: #{err}" if err or not website

      chats = [
        {
          visitor:
            username: 'Bob'
          websiteUrl: websiteUrl
          websiteId: website._id
          department: 'Sales'
          status: 'waiting'
          creationDate: now
          history: []
        }
        {
          visitor:
            username: 'Suzie'
          status: 'active'
          creationDate: now
          history: []
        }
        {
          visitor:
            username: 'Ralph'
          status: 'active'
          creationDate: now
          history: []
        }
        {
          visitor:
            username: 'Frank'
          status: 'vacant'
          creationDate: now
          history: []
        }
      ]

      Account.findOne {}, {_id: true}, (err, account) ->

        createChat = (chat, cb) ->
          Chat(account._id).create (err, c) ->
            chatData = [
              c.visitor.mset chat.visitor
              c.status.set chat.status
              c.creationDate.set chat.creationDate
              #c.history.rpush chat.history... #this needs to be a loop
            ]
            chatData.push c.websiteId.set chat.websiteId if chat.websiteId?
            chatData.push c.websiteUrl.set chat.websiteUrl if chat.websiteUrl?
            chatData.push c.department.set chat.department if chat.department?

            async.parallel chatData, (err) -> cb err, c

        async.map chats, createChat, cb

for name in ['admin', 'owner', 'guru1', 'guru2', 'guru3', 'invalid', 'wrongpassword']
  helpers["#{name}Login"] = helpers.loginBuilder name

module.exports = helpers
