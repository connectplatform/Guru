# I decided to model the newChat behavior as a Finite State Machine.  This replaces
# a heirarchy of nested callbacks which was verbose and difficult to modify.

define ["load/server", "load/notify", 'helpers/util'], (server, notify, util) ->

  ({renderForm, params}) ->

    fsm =
      transition: (err, data) ->
        if err and not data?
          fsm.states.error err

        else if not data?
          fsm.states.needChat()

        else if data.chatId
          fsm.states.gotChat data.chatId

        else if data.fields
          fsm.states.needParams err, data.fields

        else if data.noOperators
          fsm.states.noOperators()

        else if data.params
          data.params = params.merge data.params
          fsm.states.needChat()

      states:
        error: (err) ->
          $("#content").html "Oops, a problem occurred!  We've been notified, thank you for your patience."
          notify.error "Problem connecting to chat: #{err}" if err?

        initial: ->
          server.getExistingChat fsm.transition

        needChat: ->
          $("#content").html "Connecting to chat..."
          server.createChatOrGetForm params, fsm.transition

        # ask the user for additional params
        needParams: (err, fields) ->
          notify.error "Problem connecting to chat: #{err}" if err?
          renderForm fields, fsm.transition

        # redirect if we have a chat for this session
        gotChat: (chatId) ->
          window.location.hash = "/visitorChat/#{chatId}"

        noOperators: ->
          window.location.hash = "/submitQuestion/"

    return fsm