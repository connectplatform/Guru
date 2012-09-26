async = require 'async'
sugar = require 'sugar'

pulsar = config.require 'load/pulsar'
rand = config.require 'services/rand'
{getType} = config.require 'load/util'

face = (decorators) ->
  {chat: {
    visitor,
    status,
    history,
    creationDate,
    website,

    allChats,
    unansweredChats}} = decorators

  faceValue =
    create: (cb) ->
      id = "chat_#{rand()}"
      chat = faceValue.get id

      # initialization
      async.parallel [
        chat.creationDate.set Date.create()
        chat.status.set 'waiting'
        faceValue.allChats.add id

      ], (err) ->
        console.log "Error adding chat: #{err}" if err?
        cb err, chat

    get: (id) ->
      chat = id: id

      website chat
      visitor chat, ({before, after}) ->
        # JSON serialize/deserialize
        # TODO: code review
        dehydrateJSON = (obj) ->
          newObj = {}
          for key, value of obj
            if getType(value) is '[object Object]'
              newObj[key] = JSON.stringify value
            else
              newObj[key] = value
          newObj

        before ['set'], (context, [key, value], next) ->
          if (value in ['acpData', 'referrerData'])
            value = JSON.stringify value
          next null, [key, value]

        before ['mset'], (context, args, next) ->
          next null, args.map dehydrateJSON

        after ['get'], (context, data, next) ->
          next null, JSON.parse(data)

      creationDate chat, ({before, after}) ->
        before ['getset', 'set'], (context, [date], next) ->
          next null, [JSON.stringify date]

        after ['get'], (context, date, next) ->
          next null, Date.create(JSON.parse(date))

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
          visitor: chat.visitor.getall
          status: chat.status.get
          website: chat.website.get
          history: chat.history.all
          creationDate: chat.creationDate.get

        }, (err, chat) ->
          chat.id = id
          cb err, chat

      chat.delete = (cb) ->
        async.parallel [
          chat.visitor.del
          chat.status.del
          chat.website.del
          chat.creationDate.del
          chat.history.del
        ], cb

      return chat

  allChats faceValue

  unansweredChats faceValue

  return faceValue

schema =
  'chat:!{id}':
    visitor: 'Hash'
    status: 'String' # transfer, invite, waiting, active, vacant
    website: 'String'
    creationDate: 'String'
    history: 'List' # message, username, timestamp
  chat:
    allChats: 'Set'
    unansweredChats: 'Set'

module.exports = ['Chat', face, schema]
