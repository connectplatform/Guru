define ["load/server", "load/notify", "templates/editWebsite", "templates/deleteWebsite", "templates/websiteRow", "helpers/formBuilder", "helpers/submitToAws"],
  (server, notify, editWebsite, deleteWebsite, websiteRow, formBuilder, submitToAws) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->

        server.findModel {}, "Specialty", (err, specialties) ->
          validSpecialtyNames = specialties.map (specialty) -> specialty.name

          getFormFields = ->
            {
              name: $('#editWebsite .name').val()
              url: $('#editWebsite .url').val()
              specialties: ($(thing).val() for thing in $('#editWebsite .specialties :checkbox:checked'))
              acpEndpoint: $('#editWebsite .acpEndpoint').val()
              acpApiKey: $('#editWebsite .acpApiKey').val()
            }

          extraDataPacker = (website) ->
            website.allowedSpecialties = validSpecialtyNames
            website

          getNewWebsite = ->
            site = extraDataPacker {
              name: ""
              url: ""
              specialties: []
              acpEndpoint: ""
              acpApiKey: ""
            }
            site

          # find all websites and populate listing
          server.findModel {}, 'Website', (err, websites) ->
            server.log 'Error retrieving websites on websites crud page', {error: err, severity: error} if err

            beforeRender = (element, cb) ->
              server.awsUpload {siteUrl: element.url, imageName: 'logo'}, (err, logoFields) ->
                server.awsUpload {siteUrl: element.url, imageName: 'online'}, (err, onlineFields) ->
                  server.awsUpload {siteUrl: element.url, imageName: 'offline'}, (err, offlineFields) ->
                    cb {logo: logoFields, online: onlineFields, offline: offlineFields}

            beforeSubmit = (element, beforeData, cb) ->
              uploadFunc = (imageName, next) ->
                if $(".#{imageName}Upload")[0].files[0]?
                  submissionData =
                    formFields: beforeData[imageName]
                    file: $(".#{imageName}Upload")[0].files[0]
                    error: (arg) ->
                      notify.error "error submitting #{imageName} image"
                      next()
                    success: next
                  submitToAws submissionData
                else
                  next()

              # Do in parallel:
              async.parallel [
                (next) -> uploadFunc 'logo', next
                (next) -> uploadFunc 'online', next
                (next) -> uploadFunc 'offline', next
              ], cb

            #Done with edit/delete handlers, now render page
            $('#content').html templ websites: websites

            formBuild = formBuilder getFormFields, editWebsite, deleteWebsite, extraDataPacker, websiteRow, websites, "website", beforeRender, beforeSubmit

            $('#addWebsite').click formBuild.elementForm editWebsite, getNewWebsite(), (err, savedWebsite) ->
              return notify.error "Error saving website: #{err}" if err?
              formBuild.setElement savedWebsite
              $("#websiteTableBody").append websiteRow website: savedWebsite

            #Attach handlers to all rows
            formBuild.wireUpRow website.id for website in websites
