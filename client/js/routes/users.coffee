define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util"],
  (server, notify, sidebar, sbTemp, util) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->
        server.findUser {}, (err, users) ->
          console.log "err retrieving users: #{err}" if err
          sidebar {}, sbTemp

          $('#content').html templ users: users

          $('#addUser').click (evt)->
            evt.preventDefault()
            $('#user-modal').modal()
            $('#user-modal').submit ->
              fields =
                firstName: $('#user-form #firstName').val()
                lastName: $('#user-form #lastName').val()
                email: $('#user-form #email').val()
                role: $('#user-form #role').val()
                websites: $('#user-form #websites').val()
                departments: $('#user-form #departments').val()

              server.saveUser fields, (err, data) ->
                return notify.error "Error saving user: #{err}" if err?
                $('#user-modal').hide()

