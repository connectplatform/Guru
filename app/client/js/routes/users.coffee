define ['load/server', 'load/notify', 'templates/editUser', 'templates/deleteUser', 'templates/userRow', 'helpers/formBuilder'],
  (server, notify, editUser, deleteUser, userRow, formBuilder) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->

        server.findModel {modelName: 'Website', queryObject: {}}, (err, websites) ->
          if err
            server.log
              message: 'Error finding website'
              context: {error: err}

          server.findModel {modelName: 'Specialty', queryObject: {}}, (err, specialties) ->
            if err
              server.log
                message: 'Error finding specialty'
                context: {error: err}

            allowedWebsites = websites.map (site) -> {url: site.url, id: site.id}
            validSpecialtyNames = specialties.map (specialty) -> specialty.name

            server.getRoles {}, (err, allowedRoles) ->

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
                siteUrls = {}
                for site in websites
                  siteUrls[site.id] = site.url
                user.websiteUrls = (siteUrls[siteId] for siteId in user.websites)
                user.allowedRoles = allowedRoles
                user.allowedWebsites = allowedWebsites
                user.allowedSpecialties = validSpecialtyNames
                return user

              getNewUser = ->
                extraDataPacker {
                  firstName: ''
                  lastName: ''
                  email: ''
                  role: 'Operator'
                  websites: []
                  specialties: []
                }

              # find all users and populate listing
              server.findModel {modelName: 'User', queryObject: {}}, (err, users) ->
                if err
                  console.log 'Error finding user:', err
                  server.log
                    message: 'Error finding user'
                    context: {error: err}

                siteUrls = {}
                for site in websites
                  siteUrls[site.id] = site.url

                for user in users
                  user.websiteUrls = (siteUrls[siteId] for siteId in user.websites)
                  user.allowedWebsites = allowedWebsites

                $('#content').html templ users: users
                formBuild = formBuilder getFormFields, editUser, deleteUser, extraDataPacker, userRow, users, 'user'
                #Done with edit/delete handlers, now render page

                $('#addUser').click formBuild.elementForm editUser, getNewUser(), 'edit', (err, savedUser) ->
                  return notify.error "Error saving user: #{err}" if err?
                  formBuild.setElement savedUser
                  $('#userTableBody').append userRow user: savedUser

                #Attach handlers to all rows
                formBuild.wireUpRow user.id for user in users
