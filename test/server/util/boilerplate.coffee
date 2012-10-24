db = config.require 'server/load/mongo'
flushCache = config.require 'load/flushCache'
sampleData = config.require 'policy/sampleData'
stoic = require 'stoic'
async = require 'async'
should = require 'should'

# pick a port that server and client will run on
testPort = process.env.GURU_PORT = Math.floor(Math.random() * 1000) + 8000
pulsarPort = process.env.GURU_PULSAR_PORT = Math.floor(Math.random() * 1000) + 8000

# initialize vein client
http = require 'http'
Vein = require 'vein'
Pulsar = require 'pulsar'

# initialize app server
initApp = (cb) ->
  return cb() if @app?
  @app = config.require 'load/app'
  @app cb

getClient = -> Vein.createClient port: testPort

getAuthedWith = (data, cb) =>
  {Session} = stoic.models
  client = getClient()
  client.ready =>
    client.login data, (err) =>
      console.log 'error on test login:', err if err
      Session.accountLookup.get client.cookie('session'), (_, accountId) ->
        cb err, client, accountId

loginBuilder = (name) ->
  (cb) =>
    data =
      email: "#{name}@foo.com"
      password: 'foobar'
    getAuthedWith data, cb

module.exports = global.boiler = (testName, tests) ->

  describe testName, (done)->

    before (done) ->
      @getClient = getClient
      @getPulsar = -> Pulsar.createClient port: pulsarPort
      @db = db
      @testPort = testPort

      for name in ['admin', 'guru1', 'guru2', 'guru3']
        this["#{name}Login"] = loginBuilder name

      # to be backwards compatible.  maybe refactor old tests?
      @getAuthed = (cb) =>
        @adminLogin (err, @client, accountId) =>
          cb err, @client, accountId

      @getAuthedWith = getAuthedWith

      # create a chat but disconnect the visitor when done
      @newChat = (cb) =>
        @newChatWith {username: 'visitor', websiteUrl: 'foo.com'}, cb

      @newChatWith = (data, cb) =>
        @newVisitor data, (err, visitor, chatData) =>
          visitor.disconnect()
          cb err, Object.merge data, {data: chatData}

      # create a chat and hang onto visitor client
      @newVisitor = (data, cb) =>
        visitor = @getClient()
        visitor.ready =>
          visitor.newChat data, (err, data) =>
            throw new Error err.toString() if err
            @visitorSession = visitor.cookie 'session'
            @chatId = data.chatId
            cb null, visitor, data

      @expectSessionIsOnline = (sessionId, expectation, cb) ->
        {Session} = stoic.models
        Session.accountLookup.get sessionId, (err, accountId) ->
          Session(accountId).get(sessionId).online.get (err, online) =>
            should.not.exist err
            online.should.eql expectation
            cb()

      @loginOperator = (cb) =>
        @guru1Login (err, client) =>
          throw new Error err if err
          @targetSession = client.cookie 'session'
          client.disconnect()
          cb()

      @createChats = (cb) ->
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

      initApp ->
        done()

    beforeEach (done) ->
      flushCache config.redis.database, config.redis.database, =>
        sampleData (err, data) =>
          throw new Error "when creating sample data: #{err}" if err?
          @adminUser = data[0][0]
          done()

    after (done) ->
      flushCache config.redis.database, config.redis.database, ->
        db.wipe done

    afterEach ->
      @client.disconnect() if @client?.connected

    tests()
