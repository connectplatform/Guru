async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'
showToValidOperators = config.require 'services/operator/showToValidOperators'

module.exports = (res, userData) ->
  {Chat, Session, ChatSession} = stoic.models
  username = userData.username or 'anonymous'
  website = userData.params?.websiteUrl
  department = userData.department

  # pump chat data into redis
  createChatData = (next, {chat}) ->
    visitorMeta =
      username: username
      referrerData: userData.params || null

    chat.visitor.mset visitorMeta, next

  setChatWebsite = (next, {chat}) ->
    return next() unless website
    chat.website.set website, next

  setChatDepartment = (next, {chat}) ->
    return next() unless department
    chat.department.set department, next

  createChatSession = (next, {chat, session}) ->
    ChatSession.add session.id, chat.id, { isWatching: false, type: 'member' }, next

  createSession = (next) ->
    Session.create { role: 'Visitor', chatName: username }, next

  # create all necessary artifacts
  async.auto {
    session: createSession
    chat: Chat.create
    chatData: ['chat', createChatData]
    website: ['chat', setChatWebsite]
    department: ['chat', setChatDepartment]
    chatSession: ['chat', 'session', createChatSession]

  }, (err, {chat, session}) ->

    # set cookie and create pulsar channel
    res.cookie 'session', session.id
    createChannel chat.id

    # respond to visitor browser
    res.reply err, channel: chat.id

    # query for ACP data and store it in redis whenever it's available
    if userData.params
      populateVisitorAcpData userData.params, chat.id

    chatData =
      chatId: chat.id
      website: userData.website
      specialty: userData.department

    showToValidOperators chatData, ->
