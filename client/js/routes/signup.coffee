define ["app/server", "app/notify", "templates/signup"], (server, notify, templ) ->
  ->
    $('#content').append templ()
    $('#signup-modal').modal()
    $('#signup-modal #first').focus()

    $('#signup-modal').on 'hide', ->
      window.location.hash = '#/'

    $('#signup-form').submit ->
      fields =
        first: $('#signup-modal #first').val()
        last: $('#signup-modal #last').val()
        email: $('#signup-modal #email').val()
        password: $('#signup-modal #password').val()

      server.signup fields, (err, okay) ->
        return notify.error "Error during signup: #{err}" if err?
        $('#signup-modal').modal 'hide'
        window.location.hash = '#/home'

      return false

    $('#signup-cancel-button').click ->
      $('#signup-modal').modal 'hide'
      window.location.hash = '#/'

