define ["app/server", "app/notify", "routes/sidebar", "templates/sidebar", "templates/editUser", "templates/deleteUser", "templates/userRow", "app/formBuilder"],
  (server, notify, sidebar, sbTemp, editUser, deleteUser, userRow, formBuilder) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->

        server.findModel {}, "Website", (err, websites) ->

          validWebsiteNames = websites.map (site) -> site.name

          server.getRoles (err, allowedRoles) ->

            getFormFields = ->
              {
                firstName: $('#editUser .firstName').val()
                lastName: $('#editUser .lastName').val()
                email: $('#editUser .email').val()
                role: $('#editUser .role').val()
                websites: ($(thing).val() for thing in $('#editUser .websites :checkbox:checked'))
                departments: $('#editUser .departments').val()
              }

            extraDataPacker = (user) ->
              user.allowedRoles = allowedRoles
              user.allowedWebsites = validWebsiteNames
              return user

            getNewUser = ->
              extraDataPacker {
                firstName: ""
                lastName: ""
                email: ""
                role: "Operator"
                websites: []
                departments: ""
              }

            # find all users and populate listing
            server.findModel {}, "User", (err, users) ->
              console.log "err retrieving users: #{err}" if err

              formBuild = formBuilder getFormFields, editUser, deleteUser, extraDataPacker, userRow, users, "user"
              #Done with edit/delete handlers, now render page
              $('#content').html templ users: users

              $('#addUser').click formBuild.elementForm editUser, getNewUser(), (err, savedUser) ->
                return notify.error "Error saving user: #{err}" if err?
                formBuild.setElement savedUser
                $("#userTableBody").append userRow user: savedUser

              #Attach handlers to all rows
              formBuild.wireUpRow user.id for user in users
