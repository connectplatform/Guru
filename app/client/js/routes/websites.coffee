define ["load/server", "load/notify", "templates/editWebsite", "templates/deleteWebsite", "templates/websiteRow", "helpers/formBuilder"],
  (server, notify, editWebsite, deleteWebsite, websiteRow, formBuilder) ->
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
            console.log site
            site

          # find all websites and populate listing
          server.findModel {}, "Website", (err, websites) ->
            console.log "err retrieving websites: #{err}" if err

            formBuild = formBuilder getFormFields, editWebsite, deleteWebsite, extraDataPacker, websiteRow, websites, "website"
            #Done with edit/delete handlers, now render page
            $('#content').html templ websites: websites

            $('#addWebsite').click formBuild.elementForm editWebsite, getNewWebsite(), (err, savedWebsite) ->
              return notify.error "Error saving website: #{err}" if err?
              formBuild.setElement savedWebsite
              $("#websiteTableBody").append websiteRow website: savedWebsite

            #Attach handlers to all rows
            formBuild.wireUpRow website.id for website in websites
