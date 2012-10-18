define ["load/server", "load/notify", "templates/editUser", "templates/deleteUser", "templates/userRow", "helpers/formBuilder"],
  (server, notify, editUser, deleteUser, userRow, formBuilder) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->

        server.findModel {}, "Website", (err, websites) ->
          server.findModel {}, "Specialty", (err, specialties) ->

            allowedWebsites = websites.map (site) -> {name: site.name, id: site.id}
            validSpecialtyNames = specialties.map (specialty) -> specialty.name

            server.getRoles (err, allowedRoles) ->

              getFormFields = ->
                {
                  firstName: $('#editUser .firstName').val()
                  lastName: $('#editUser .lastName').val()
                  email: $('#editUser .email').val()
                  role: $('#editUser .role').val()
                  websites: ($(thing).attr('websiteId') for thing in $('#editUser .websites :checkbox:checked'))
                  specialties: ($(thing).val() for thing in $('#editUser .specialties :checkbox:checked'))
                }

              extraDataPacker = (user) ->
                user.allowedRoles = allowedRoles
                user.allowedWebsites = allowedWebsites
                user.allowedSpecialties = validSpecialtyNames
                return user

              getNewUser = ->
                extraDataPacker {
                  firstName: ""
                  lastName: ""
                  email: ""
                  role: "Operator"
                  websites: []
                  specialties: []
                }

              # find all users and populate listing
              server.findModel {}, "User", (err, users) ->
                server.log 'Error retrieving users on users crud page', {error: err, severity: 'error'} if err

                siteNames = {}
                for site in websites
                  siteNames[site.id] = site.name

                console.log 'siteNames: ', siteNames

                for user in users
                  user.websiteNames = (siteNames[site] for site in user.websites)
                  console.log 'user.websiteNames: ', user.websiteNames

                $('#content').html templ users: users
                formBuild = formBuilder getFormFields, editUser, deleteUser, extraDataPacker, userRow, users, "user"
                #Done with edit/delete handlers, now render page

                $('#addUser').click formBuild.elementForm editUser, getNewUser(), (err, savedUser) ->
                  return notify.error "Error saving user: #{err}" if err?
                  formBuild.setElement savedUser
                  $("#userTableBody").append userRow user: savedUser

                #Attach handlers to all rows
                formBuild.wireUpRow user.id for user in users
