# I decided to model the newChat behavior as a Finite State Machine.  This replaces
# a heirarchy of nested callbacks which was verbose and difficult to modify.

# TODO: generalize, move 'states' definition into newChat route
define ["load/server", "load/notify", 'helpers/util', 'helpers/renderForm'],
  (server, notify, util, renderForm) ->

    ({params}) ->

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
            $("#content .form-area").html "Oops, a problem occurred!  We've been notified, thank you for your patience."
            if err
              server.log
                message: 'Problem connecting to chat.',
                context: {error: err}

          initial: ->
            server.getExistingChat {}, fsm.transition

          needChat: ->
            $("#content .form-area").html "Connecting to chat..."
            server.createChatOrGetForm params, fsm.transition

          # ask the user for additional params
          needParams: (err, fields) ->
            notify.error "Problem connecting to chat: #{err}" if err

            options =
              name: 'newChat'
              submitText: 'Enter Chat'
              placement: '#content .form-area'

            renderForm options, fields, (params) ->
              fsm.transition null, {params: params}

          # redirect if we have a chat for this session
          gotChat: (chatId) ->
            window.location.hash = "/visitorChat/#{chatId}"

          noOperators: () ->
            window.location.hash = "/submitQuestion?#{$.param params}"

      fsm.states.initial()
