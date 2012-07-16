pulsar = require '../../pulsar'
async = require 'async'
rand = require '../../../lib/rand'
{inspect} = require 'util'

face = (decorators) ->
  {chat: {
    visitor,
    visitorPresent,
    unanswered,
    history,
    creationDate,

    allChats,
    unansweredChats}} = decorators

  faceValue =
    create: (cb) ->
      id = "chat_#{rand()}"
      chat = @get id

      # initialization
      async.parallel [
        chat.creationDate.set Date.now()
        chat.unanswered.set 'true'
        @allChats.add id
      ], (err) ->

        console.log "Error adding chat: #{err}" if err?
        cb err, chat

    get: (id) ->
      chat = id: id

      visitor chat, ({before, after}) ->
        # JSON serialize/deserialize
        before ['set'], (context, args, next) ->
          next null, args.map JSON.stringify
        after ['get'], (context, data, next) ->
          next null, JSON.parse(data)

      visitorPresent chat
      creationDate chat
      unanswered chat, ({before, after}) ->

        # whenever a chat's unanswered status is set, add/remove it from the unanswered chats list
        before ['set'], (context, [val], next) ->
          switch val
            when 'true'
              faceValue.unansweredChats.add id, ->
            when 'false'
              faceValue.unansweredChats.srem id, ->

          next null, [val]

      history chat, ({before, after}) ->

        # JSON serialize/deserialize
        before ['rpush'], (context, args, next) ->
          next null, args.map JSON.stringify
        after ['all'], (context, data, next) ->
          next null, data.map JSON.parse

      chat.dump = (cb) ->

        async.parallel {
          visitor: chat.visitor.get
          visitorPresent: chat.visitorPresent.get
          history: chat.history.all
          creationDate: chat.creationDate.get
          unanswered: chat.unanswered.get

        }, (err, chat) ->
          chat.id = id
          chat.creationDate = new Date parseInt chat.creationDate
          cb err, chat

      return chat

  allChats faceValue

  unansweredChats faceValue, ({before, after}) ->

    # whenever an unansweredChat is added/removed, notify the operators
    after ['add', 'srem'], (context, args, next) ->
      faceValue.unansweredChats.count (err, chatCount) ->

        notify = pulsar.channel 'notify:operators'
        notify.emit 'unansweredCount', chatCount
        console.log "sent unanswered count #{chatCount}"
      next null, args

  return faceValue

schema =
  'chat:!{id}':
    visitor: 'String' #TODO make this a type that JSON.parses automatically
    visitorPresent: 'String'
    unanswered: 'String'
    history: 'List'
    creationDate: 'String'
  chat:
    allChats: 'Set'
    unansweredChats: 'Set'

module.exports = ['Chat', face, schema]
