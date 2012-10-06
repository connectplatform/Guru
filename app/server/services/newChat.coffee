async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'
showToValidOperators = config.require 'services/operator/showToValidOperators'

module.exports = (res, userData) ->
  {Chat, Session, ChatSession} = stoic.models

  website = userData.websiteUrl
  department = userData.department
  username = userData.username or 'anonymous'

  # pump chat data into redis
  createChatData = (next, {chat}) ->
    visitorMeta =
      username: username
      referrerData: userData || null

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

  show = (next, {chat}) ->
    chatData =
      chatId: chat.id
      website: website
      specialty: department

    showToValidOperators chatData, next

  # create all necessary artifacts
  async.auto {
    session: createSession
    chat: Chat.create
    chatData: ['chat', createChatData]
    website: ['chat', setChatWebsite]
    department: ['chat', setChatDepartment]
    chatSession: ['chat', 'session', createChatSession]
    show: ['chat', show]

  }, (err, {chat, session}) ->

    # set cookie and create pulsar channel
    res.cookie 'session', session.id
    createChannel chat.id

    # respond to visitor browser
    res.reply err, chatId: chat.id

    # query for ACP data and store it in redis whenever it's available
    if userData
      populateVisitorAcpData userData, chat.id
