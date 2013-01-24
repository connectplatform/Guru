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
  wrapVeinClient: (client, localStorage) ->
    utility = ['disconnect', 'cookie']

    wrapped = {}
    wrapped.localStorage = localStorage
    # proxy services, merging any local data (e.g. sessionId)
    for serviceName, serviceDef of client when serviceName not in utility
      do (serviceName, serviceDef) ->
        wrapped[serviceName] = (args..., done) ->
          args = args[0] || {}
          serviceDef args.merge(wrapped.localStorage), done

    # bind utility functions
    for serviceName, serviceDef of client when serviceName in utility
      wrapped[serviceName] = serviceDef.bind client

    return wrapped

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

          # vein doesn't handle cookies, but we want client side middleware to do it
          wrappedClient = helpers.wrapVeinClient client, {sessionId: sessionId}
          cb err, wrappedClient, {sessionId: sessionId, accountId: accountId}

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
      #TODO: map specialties to IDs
      visitor.newChat data, (err, chatData) =>
        throw new Error err if err
        @visitorSession = chatData.sessionId
        @chatId = chatData.chatId

        # vein doesn't handle cookies, but we want client side middleware to do it
        wrappedClient = helpers.wrapVeinClient visitor, {sessionId: chatData.sessionId}
        cb null, wrappedClient, data.merge(chatData)

  # create a chat but disconnect the visitor when done
  newChatWith: (data, cb) ->
    @newVisitor data, (err, visitor, chatData) ->
      visitor.disconnect()
      cb err, chatData

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
    @guru1Login (err, client, args) =>
      throw new Error err if err
      @targetSession = args?.sessionId
      cb null, client, args

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
          specialtyName: 'Sales'
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
            chatData.push c.specialtyId.set chat.specialtyId if chat.specialtyId? #TODO: map specialtyIDs

            async.parallel chatData, (err) -> cb err, c

        async.map chats, createChat, cb

for name in ['admin', 'owner', 'guru1', 'guru2', 'guru3', 'invalid', 'wrongpassword']
  helpers["#{name}Login"] = helpers.loginBuilder name

module.exports = helpers
