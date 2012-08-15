pulsar = require '../../pulsar'
async = require 'async'
rand = require '../../../lib/rand'
{inspect} = require 'util'

face = (decorators) ->
  {chat: {
    visitor,
    status,
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
        chat.status.set 'waiting'
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

      creationDate chat
      status chat, ({before, after}) ->

        # whenever a chat's unanswered status is set, add/remove it from the unanswered chats list
        before ['getset', 'set'], (context, [val], next) ->
          if val == 'waiting'
            faceValue.unansweredChats.add id, ->
          else
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
          status: chat.status.get
          history: chat.history.all
          creationDate: chat.creationDate.get

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
      next null, args

  return faceValue

schema =
  'chat:!{id}':
    visitor: 'String' #TODO: make this a hash
    status: 'String' # transfer, invite, waiting, active, vacant
    creationDate: 'String'
    history: 'List' # message, username, timestamp
  chat:
    allChats: 'Set'
    unansweredChats: 'Set'

module.exports = ['Chat', face, schema]
