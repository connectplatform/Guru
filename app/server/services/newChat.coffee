async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'

module.exports = (res, userData) ->
  {Chat, Session, ChatSession} = stoic.models
  username = userData.username or 'anonymous'

  # pump chat data into redis
  createChatData = (next, {chat}) ->
    visitorMeta =
      username: username
      department: null
      referrerData: userData.referrerData || null

    chat.visitor.mset visitorMeta, next

  setChatWebsite = (next, {chat}) ->
    website = userData.referrerData?.websiteUrl
    return next() unless website
    chat.website.set website, next

  createChatSession = (next, {chat, session}) ->
    ChatSession.add session.id, chat.id, { isWatching: false, type: 'member' }, next

  #TODO: why doesn't tandoor work?
  createSession = (next) ->
    Session.create { role: 'Visitor', chatName: username }, next

  # create all necessary artifacts
  async.auto {
    session: createSession
    chat: Chat.create
    chatData: ['chat', createChatData]
    website: ['chat', setChatWebsite]
    chatSession: ['chat', 'session', createChatSession]

  }, (err, {chat, session}) ->

    # set cookie and create pulsar channel
    res.cookie 'session', session.id
    createChannel chat.id

    # respond to visitor browser
    res.reply err, channel: chat.id

    # query for ACP data and store it in redis whenever it's available
    if userData.referrerData
      populateVisitorAcpData userData.referrerData, chat.id

    #displayToOperators chat, ->
