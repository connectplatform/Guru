db = config.require 'server/load/mongo'
async = require 'async'
should = require 'should'
{inspect} = require 'util'

Vein = require 'vein'

testPort = process.env.GURU_PORT

#Exported object of helper functions
helpers =

  logger: config.require 'lib/logger'

  # keep track of how many tests we've run
  count: 0

  # keep track of vein clients so we can disconnect them in cleanup
  clients: []

  wrapVeinClient: (client, localStorage) ->
    utility = ['disconnect', 'cookie', 'ready']

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
    helpers.clients.push client

    if receive
      client.ready ->
        receive client
    else
      return client

  testPort: testPort

  loginBuilder: (name) ->
    (cb) =>
      data =
        email: "#{name}@foo.com"
        password: 'foobar'
      @getAuthedWith data, cb

  getAuthedWith: (data, cb) ->
    {Session} = db.models
    client = @getClient()
    client.ready =>
      client.login data, (err, {sessionSecret}) =>
        console.log 'error on test login:', err if err or not sessionSecret
        if err
          cb err, null, {}
        else
          Session.findOne {secret: sessionSecret}, (err, session) ->
            @sessionSecret = sessionSecret
            @accountId = session.accountId
            @sessionId = session._id
            # vein doesn't handle cookies, but we want client side middleware to do it
            wrappedClient = helpers.wrapVeinClient client, {@sessionSecret, @sessionId}
            cb err, wrappedClient, {sessionSecret, @sessionId, @accountId}

  # to be backwards compatible.  maybe refactor old tests?
  getAuthed: (cb) ->
    @ownerLogin (err, @client, vars) =>
      {@accountId, @sessionSecret, @sessionId} = vars
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
        # wrappedClient = helpers.wrapVeinClient visitor, {sessionId: chatData.sessionId}
        wrappedClient = helpers.wrapVeinClient visitor, chatData
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
    {Session} = db.models
    Session.accountLookup.get sessionId, (err, accountId) ->
      Session(accountId).get(sessionId).online.get (err, online) =>
        should.not.exist err
        online.should.eql expectation
        cb()

  loginOperator: (cb) ->
    @guru1Login (err, client, args) =>
      throw new Error err if err
      @targetSessionId = args?.sessionId
      cb null, client, args

  createChats: (cb) ->
    now = Date.create().getTime()

    {Account, Chat, Website} = db.models

    websiteUrl = 'foo.com'
    Website.findOne {url: websiteUrl}, (err, website) ->
      throw new Error "Could not find website [#{websiteUrl}]: #{err}" if err or not website

      chats = [
        {
          name: 'Bob'
          websiteUrl: websiteUrl
          websiteId: website._id
          specialtyName: 'Sales'
          status: 'Waiting'
          creationDate: now
          history: []
        }
        {
          name: 'Suzie'
          status: 'Active'
          creationDate: now
          history: []
        }
        {
          name: 'Ralph'
          status: 'Active'
          creationDate: now
          history: []
        }
        {
          name: 'Frank'
          status: 'Vacant'
          creationDate: now
          history: []
        }
      ]

      Account.findOne {}, {_id: true}, (err, account) ->

        createChat = (chatData, cb) ->
          data =
            accountId: account._id
            websiteId: website._id
            websiteUrl: website.url
          data.merge chatData
          Chat.create data, cb

        async.map chats, createChat, cb

for name in ['admin', 'owner', 'guru1', 'guru2', 'guru3', 'invalid', 'wrongpassword']
  helpers["#{name}Login"] = helpers.loginBuilder name

module.exports = helpers
