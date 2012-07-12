define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "app/util"],
  (server, notify, sidebar, sbTemp, util) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      getFormFields = ->
        {
          firstName: $('#user-form #firstName').val()
          lastName: $('#user-form #lastName').val()
          email: $('#user-form #email').val()
          role: $('#user-form #role').val()
          websites: $('#user-form #websites').val()
          departments: $('#user-form #departments').val()
        }

      setFormFields = (currentUser) ->
        $('#user-form #firstName').val(currentUser.firstName)
        $('#user-form #lastName').val(currentUser.lastName)
        $('#user-form #email').val(currentUser.email)
        $('#user-form #role').val(currentUser.role)
        $('#user-form #websites').val(currentUser.websites)
        $('#user-form #departments').val(currentUser.departments)


      server.ready ->
        server.findUser {}, (err, users) ->
          console.log "err retrieving users: #{err}" if err
          sidebar {}, sbTemp

          $('#content').html templ users: users

          getUserById = (id) ->
            for user in users
              return user if user.id is id

          #TODO there's significant duplication here
          $('#addUser').click (evt)->
            evt.preventDefault()
            $('#user-modal').modal()
            $('#user-modal').submit (evt) ->
              evt.preventDefault()

              fields = getFormFields()

              server.saveUser fields, (err, data) ->
                return notify.error "Error saving user: #{err}" if err?
                $('#user-modal').modal 'hide'
                #TODO: find a way to make the table update

          $('.editUser').click (evt)->
            evt.preventDefault()
            $('#user-modal').modal()

            currentUser = getUserById $(this).attr 'userId'
            setFormFields currentUser

            $('#user-modal').submit (evt) ->
              evt.preventDefault()

              fields = getFormFields()
              fields.id = currentUser.id

              server.saveUser fields, (err, data) ->
                return notify.error "Error saving user: #{err}" if err?
                $('#user-modal').modal 'hide'
                #TODO: find a way to make the table update

          $('.deleteUser').click (evt)->
            evt.preventDefault()
            currentUser = getUserById $(this).attr 'userId'
            $('#delete-modal').modal()
            $('#delete-modal #delete-prompt').val "Are you sure you want to delete user #{currentUser.email}?"

            $('#user-modal').submit (evt) ->
              evt.preventDefault()

              server.deleteUser currentUser.id, (err) ->
                return notify.error "Error deleting user: #{err}" if err?
                $('#user-modal').modal 'hide'
                #TODO: find a way to make the table update
















