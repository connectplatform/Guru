async = require 'async'
stoic = require 'stoic'

createChannel = config.require 'services/chats/createChannel'
populateVisitorAcpData = config.require 'services/populateVisitorAcpData'
getAvailableOperators = config.require 'services/operator/getAvailableOperators'

module.exports = (res, userData) ->
  {Chat, Session, ChatSession} = stoic.models

  return res.reply "Field required: websiteUrl" unless userData?.websiteUrl

  website = userData.websiteUrl
  department = userData.department
  username = userData.username or 'anonymous'

  #console.log 'website:', website
  #console.log 'department:', department
  getAvailableOperators website, department, (err, operators) ->
    #console.log 'operators:', operators
    console.log 'Error getting operators:', err if err
    return res.reply err, {noOperators: true} if err or operators.length is 0

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

    # create a chat session for each valid operator
    show = (next, {chat}) ->
      notify = (op, next) ->
        Session.get(op.sessionId).unansweredChats.add chat.id, next

      async.map operators, notify, next

    # create all necessary artifacts
    async.auto {
      session: createSession
      chat: Chat.create
      chatData: ['chat', createChatData]
      website: ['chat', setChatWebsite]
      department: ['chat', setChatDepartment]
      show: ['chat', show]
      chatSession: ['chat', 'session', createChatSession]

    }, (err, {chat, session}) ->

      # set cookie and create pulsar channel
      res.cookie 'session', session.id
      createChannel chat.id

      # respond to visitor browser
      res.reply err, chatId: chat.id

      # query for ACP data and store it in redis
      populateVisitorAcpData userData, chat.id
