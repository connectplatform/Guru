define ["load/server", "load/notify", "routes/sidebar", "templates/sidebar", "helpers/util", "policy/registerSessionUpdates"],
  (server, notify, sidebar, sbTemp, util, registerSessionUpdates) ->
    (args, templ) ->

      $('#content').html templ()
      $('#login-modal').modal()
      $('#login-modal #email').focus()

      $('#login-modal').on 'hide', ->
        window.location.hash = '/'

      $('#login-form').submit (evt) ->
        evt.preventDefault()
        fields =
          email: $('#login-form #email').val()
          password: $('#login-form #password').val()

        server.ready ->
          server.login fields, (err, {sessionId}) ->
            return notify.error "Error logging in: #{err}" if err?
            $.cookies.set 'session', sessionId
            $('#login-modal').modal 'hide'
            registerSessionUpdates()
            window.location.hash = '/dashboard'


      $('#login-cancel-button').click ->
        $('#login-modal').modal 'hide'
        window.location.hash = '/'

      $('#forgot-password-link').click ->
        $('#login-modal').modal 'hide'
