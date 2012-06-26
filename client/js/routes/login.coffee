define ["app/server", "app/notify"], (server, notify) ->
  (args, templ) ->
    $('#content').html ''
    $('#sidebar').html ''

    $('#content').append templ()
    $('#login-modal').modal()
    $('#login-modal #email').focus()

    $('#login-modal').on 'hide', ->
      window.location.hash = '#/'

    $('#login-form').submit ->
      fields =
        email: $('#login-form #email').val()
        password: $('#login-form #password').val()

      server.ready ->
        server.login fields, (err, user) ->
          return notify.error "Error logging in: #{err}" if err?
          $('#login-modal').modal 'hide'
          window.location.hash = '#/dashboard'

      return false

    $('#login-cancel-button').click ->
      $('#login-modal').modal 'hide'
      window.location.hash = '#/'
