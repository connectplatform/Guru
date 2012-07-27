define ["app/server", "app/notify", "templates/editUser", "templates/deleteUser", "templates/userRow"],
  (server, notify, editUser, deleteUser, userRow) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      getFormFields = ->
        {
          firstName: $('#editUser .firstName').val()
          lastName: $('#editUser .lastName').val()
          email: $('#editUser .email').val()
          role: $('#editUser .role').val()
          websites: $('#editUser .websites').val()
          departments: $('#editUser .departments').val()
        }

      server.ready ->

        server.getRoles (err, allowedRoles) ->

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

          server.findUser {}, (err, users) ->
            console.log "err retrieving users: #{err}" if err?

            getUserById = (id) ->
              for user in users
                return user if user.id is id

            wireUpRow = (id) =>
              editUserClicked = (evt) ->
                evt.preventDefault()
                currentUser = getUserById $(this).attr 'userId'
                currentUser.allowedRoles = allowedRoles

                $("#modalBox").html editUser user: currentUser
                $('#editUser').modal()

                $('#editUser .saveButton').click (evt) ->
                  evt.preventDefault()

                  fields = getFormFields()
                  fields.id = currentUser.id

                  server.saveUser fields, (err, savedUser) ->
                    return notify.error "Error saving user: #{err}" if err?

                    $("#userTableBody .userRow[userId=#{currentUser.id}]").replaceWith userRow user: savedUser
                    wireUpRow(currentUser.id)
                    $('#editUser').modal 'hide'

                $('#editUser .cancelButton').click (evt) ->
                  evt.preventDefault()
                  $('#editUser').modal 'hide'

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

            #Wire up addUser
            $('#addUser').click (evt) ->
              evt.preventDefault()

              $("#modalBox").html editUser user: getNewUser()
              $('#editUser').modal()

              $('#editUser .saveButton').click (evt) ->
                evt.preventDefault()

                fields = getFormFields()

                server.saveUser fields, (err, savedUser) ->
                  return notify.error "Error saving user: #{err}" if err?
                  users.push savedUser
                  $("#userTableBody").append userRow user: savedUser
                  wireUpRow(savedUser.id)
                  $('#editUser').modal 'hide'

              $('#editUser .cancelButton').click (evt) ->
                evt.preventDefault()
                $('#editUser').modal 'hide'

            #Attach handlers to all rows
            wireUpRow user.id for user in users
