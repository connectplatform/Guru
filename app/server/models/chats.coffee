async = require 'async'
sugar = require 'sugar'

{getType, random} = config.require 'load/util'

face = (decorators) ->
  {account: {chat: {
    visitor,
    status,
    history,
    creationDate,
    websiteId,
    websiteUrl,
    department,

    allChats,
    unansweredChats}}} = decorators

  (accountId) ->
    throw new Error "Chat called without accountId: #{accountId}" unless accountId and accountId isnt 'undefined'

    faceValue =
      accountId: accountId

      create: (cb) ->
        id = "chat_#{random()}"
        chat = faceValue.get id

        # initialization
        async.parallel [
          chat.creationDate.set Date.create()
          chat.status.set 'waiting'
          faceValue.allChats.add id

        ], (err) ->
          config.log.error "Error creating chat model", {error: err, chatId: id} if err
          cb err, chat

      get: (id) ->
        if getType(id) is 'Object'
          id = id.chatId
        chat =
          id: id
          accountId: accountId

        websiteId chat
        websiteUrl chat
        department chat

        visitor chat, ({before, after}) ->
          # JSON serialize/deserialize
          # TODO: code review
          dehydrateJSON = (obj) ->
            newObj = {}
            for key, value of obj
              if getType(value) is 'Object'
                newObj[key] = JSON.stringify value
              else
                newObj[key] = value
            newObj

          before ['set'], (context, [key, value], next) ->
            if (key in ['acpData', 'referrerData'])
              value = JSON.stringify value
            next null, [key, value]

          before ['mset'], (context, args, next) ->
            next null, args.map dehydrateJSON

          after ['getall', 'retrieve'], (context, data, next) ->
            result = Object.map data, (k, v) ->
              try
                v = JSON.parse v
              return v

            next null, result

          after ['get'], (context, data, next) ->
            next null, JSON.parse(data)

        creationDate chat, ({before, after}) ->
          before ['getset', 'set'], (context, [date], next) ->
            next null, [JSON.stringify date]

          after ['get', 'retrieve'], (context, date, next) ->
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
          after ['all', 'retrieve'], (context, data, next) ->
            parsed = data.map JSON.parse
            for entry in parsed
              entry.timestamp = new Date(parseInt(entry.timestamp))
            next null, parsed

        chat.dump = (cb) ->
          return cb 'Chat does not exist' unless id
          faceValue.exists id, (err, exists) ->
            return cb err if err
            return cb 'Chat does not exist' unless exists

            async.parallel {
              visitor: chat.visitor.getall
              status: chat.status.get
              websiteId: chat.websiteId.get
              websiteUrl: chat.websiteUrl.get
              department: chat.department.get
              history: chat.history.all
              creationDate: chat.creationDate.get

            }, (err, chat) ->
              chat.id = id
              cb err, chat

        chat.delete = (cb) ->
          async.parallel [
            chat.visitor.del
            chat.status.del
            chat.websiteId.del
            chat.websiteUrl.del
            chat.department.del
            chat.creationDate.del
            chat.history.del
          ], cb

        return chat

      exists: (id, cb) ->
        faceValue.allChats.ismember id, cb

    allChats faceValue

    unansweredChats faceValue

    return faceValue

schema =
  'account:!{accountId}':
    'chat:!{id}':
      visitor: 'Hash'
      status: 'String' # transfer, invite, waiting, active, vacant
      websiteId: 'String'
      websiteUrl: 'String'
      department: 'String'
      creationDate: 'String'
      history: 'List' # message, username, timestamp
    chat:
      allChats: 'Set'
      unansweredChats: 'Set'

module.exports = ['Chat', face, schema]
