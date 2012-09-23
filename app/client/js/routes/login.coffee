setLogoffOnPageExit = (server) ->
  console.log "logoff set"
  $(window).unload ->
    sessionId = server.cookie('session')
    server.cookie 'session', null
    console.log "cookie after unload: ", server.cookie 'session'
    server.setSessionOffline sessionId, ->

define ["load/server", "load/notify", "routes/sidebar", "templates/sidebar", "helpers/util", "policy/registerSessionUpdates"],
  (server, notify, sidebar, sbTemp, util, registerSessionUpdates) ->
    (args, templ) ->
      console.log "routed to login"

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
          server.login fields, (err, user) ->
            return notify.error "Error logging in: #{err}" if err?
            $('#login-modal').modal 'hide'
            registerSessionUpdates()
            setLogoffOnPageExit server
            window.location.hash = '/dashboard'

      $('#login-cancel-button').click ->
        $('#login-modal').modal 'hide'
        window.location.hash = '/'

      $('#forgot-password-link').click ->
        $('#login-modal').modal 'hide'
