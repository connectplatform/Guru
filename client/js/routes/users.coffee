define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/editUser", "templates/deleteUser", "templates/userRow"],
  (server, notify, sidebar, sbTemp, editUser, deleteUser, userRow) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->

        server.getRoles (err, allowedRoles) ->

          getFormFields = ->
            {
              firstName: $('#editUser .firstName').val()
              lastName: $('#editUser .lastName').val()
              email: $('#editUser .email').val()
              role: $('#editUser .role').val()
              websites: $('#editUser .websites').val()
              departments: $('#editUser .departments').val()
            }

          getNewUser = ->
            {
              firstName: ""
              lastName: ""
              email: ""
              role: "Operator"
              websites: ""
              departments: ""
              allowedRoles: allowedRoles
            }

          # find all users and populate listing
          server.findUser {}, (err, users) ->
            console.log "err retrieving users: #{err}" if err
            sidebar {}, sbTemp

            getUserById = (id) ->
              for user in users
                if user.id is id
                  user.allowedRoles = allowedRoles
                  return user

            formBuilder =
              userForm: (template, user, onComplete) ->
                (evt) ->
                  evt.preventDefault()

                  $("#modalBox").html template user: user
                  $('#editUser').modal()

                  $('#editUser .saveButton').click (evt) ->
                    evt.preventDefault()

                    fields = getFormFields()
                    fields.id = user.id if user.id?

                    server.saveUser fields, (err, savedUser) ->
                      onComplete err, savedUser
                      return if err?

                      formBuilder.wireUpRow(savedUser.id)
                      $('#editUser').modal 'hide'

                  $('#editUser .cancelButton').click (evt) ->
                    evt.preventDefault()
                    $('#editUser').modal 'hide'

              wireUpRow: (id) =>
                currentUser = getUserById id

                editUserClicked = formBuilder.userForm editUser, currentUser, (err, savedUser) ->
                  return notify.error "Error saving user: #{err}" if err?
                  $("#userTableBody .userRow[userId=#{currentUser.id}]").replaceWith userRow user: savedUser

                deleteUserClicked = (evt) ->
                  evt.preventDefault()
                  currentUser = getUserById $(this).attr 'userId'

                  $("#modalBox").html deleteUser user: currentUser
                  $('#deleteUser').modal()

                  $('#deleteUser .deleteButton').click (evt) ->
                    evt.preventDefault()

                    server.deleteUser currentUser.id, (err) ->
                      return notify.error "Error deleting user: #{err}" if err?
                      $("#userTableBody .userRow[userId=#{currentUser.id}]").remove()
                      $('#deleteUser').modal 'hide'

                  $('#deleteUser .cancelButton').click ->
                    $('#deleteUser').modal 'hide'

                $("#userTableBody .userRow[userId=#{id}] .editUser").click editUserClicked
                $("#userTableBody .userRow[userId=#{id}] .deleteUser").click deleteUserClicked

            #Done with edit/delete handlers, now render page
            $('#content').html templ users: users

            $('#addUser').click formBuilder.userForm editUser, getNewUser(), (err, savedUser) ->
              return notify.error "Error saving user: #{err}" if err?
              users.push savedUser
              $("#userTableBody").append userRow user: savedUser

            #Attach handlers to all rows
            formBuilder.wireUpRow user.id for user in users
