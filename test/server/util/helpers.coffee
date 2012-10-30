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
  getClient: -> Vein.createClient port: testPort
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
      client.login data, (err) =>
        console.log 'error on test login:', err if err
        Session.accountLookup.get client.cookie('session'), (_, accountId) ->
          cb err, client, accountId

  # to be backwards compatible.  maybe refactor old tests?
  getAuthed: (cb) ->
    @ownerLogin (err, @client, accountId) =>
      cb err, @client, accountId

  # create a chat and hang onto visitor client
  newVisitor: (data, cb) ->
    visitor = @getClient()
    visitor.ready =>
      visitor.newChat data, (err, data) =>
        throw err if err
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

    chats = [
      {
        visitor:
          username: 'Bob'
        website: 'foo.com'
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

    {Account} = db.models
    Account.findOne {}, {_id: true}, (err, account) ->

      createChat = (chat, cb) ->
        Chat(account._id).create (err, c) ->
          chatData = [
            c.visitor.mset chat.visitor
            c.status.set chat.status
            c.creationDate.set chat.creationDate
            #c.history.rpush chat.history... #this needs to be a loop
          ]
          chatData.push c.website.set chat.website if chat.website?
          chatData.push c.department.set chat.department if chat.department?

          async.parallel chatData, (err) -> cb err, c

      async.map chats, createChat, cb

for name in ['admin', 'owner', 'guru1', 'guru2', 'guru3']
  helpers["#{name}Login"] = helpers.loginBuilder name

module.exports = helpers
