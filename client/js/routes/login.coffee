define ["guru/server", "guru/notify", "templates/login"], (server, notify, templ) ->
  (args, templ) ->
    $('#content').append templ()
    $('#login-modal').modal()
    $('#login-modal #email').focus()

    $('#login-modal').on 'hide', ->
      window.location.hash = '#/'

    $('#login-form').submit ->
      fields =
        email: $('#login-form #email').val()
        password: $('#login-form #password').val()

      server.login fields, (err, user) ->
        return notify.error "Error logging in: #{err}" if err?
        $('#login-modal').modal 'hide'
        window.location.hash = '#/home'

      return false

    $('#login-cancel-button').click ->
      $('#login-modal').modal 'hide'
      window.location.hash = '#/'

