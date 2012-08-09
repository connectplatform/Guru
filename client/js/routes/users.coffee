define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/editUser", "templates/deleteUser", "templates/userRow", "app/formBuilder"],
  (server, notify, sidebar, sbTemp, editUser, deleteUser, userRow, formBuilder) ->
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

          extraDataPacker = (user) ->
            user.allowedRoles = allowedRoles
            return user

          # find all users and populate listing
          server.findUser {}, (err, users) ->
            console.log "err retrieving users: #{err}" if err

            formBuild = formBuilder getFormFields, editUser, deleteUser, server.saveUser, server.deleteUser, extraDataPacker, userRow, users
            #Done with edit/delete handlers, now render page
            $('#content').html templ users: users

            $('#addUser').click formBuild.addElement getNewUser(), (err, savedUser) ->
              return notify.error "Error saving user: #{err}" if err?
              $("#userTableBody").append userRow user: savedUser

            #TODO: revert this, and manually set the new value in formBuild
            #$('#addUser').click formBuild.userForm editUser, getNewUser(), (err, savedUser) ->
              #return notify.error "Error saving user: #{err}" if err?
              #users.push savedUser
              #$("#userTableBody").append userRow user: savedUser

            #Attach handlers to all rows
            formBuild.wireUpRow user.id for user in users
