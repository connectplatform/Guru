define ['load/server', 'load/notify', 'templates/editWebsite', 'templates/deleteWebsite', 'templates/websiteRow', 'helpers/formBuilder', 'helpers/submitToAws', 'templates/embedLink', 'helpers/util'],
  (server, notify, editWebsite, deleteWebsite, websiteRow, formBuilder, submitToAws, embedLink, {formToHash}) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->

        server.findModel {modelName: 'Specialty', queryObject:{}}, (err, specialties) ->
          validSpecialtyNames = specialties.map (specialty) -> specialty.name

          getFormFields = -> formToHash $('#editWebsite form')

          extraDataPacker = (website) ->
            website.allowedSpecialties = validSpecialtyNames
            website

          getNewWebsite = ->
            site = extraDataPacker {
              contactEmail: ''
              name: ''
              url: ''
              specialties: []
              acpEndpoint: ''
              acpApiKey: ''
            }
            site

          # find all websites and populate listing
          server.findModel {modelName: 'Website', queryObject:{}}, (err, websites) ->
            if err
              server.log
                message: 'Error retrieving websites on websites crud page'
                context: {error: err, severity: 'error'}

            # TODO: use async.parallel
            beforeRender = (element, cb) ->

              console.log 'before render on ID:', element.id
              getAwsForm = (imageName) ->
                (cb) -> server.awsUpload {siteId: element.id, imageName: imageName}, cb

              getImageUrl = (imageName) ->
                (cb) -> server.getImageUrl {websiteId: element.id, imageName: imageName}, cb

              async.parallel {
                logo: getAwsForm 'logo'
                online: getAwsForm 'online'
                offline: getAwsForm 'offline'
                logoImage: getImageUrl 'logo'
                onlineImage: getImageUrl 'online'
                offlineImage: getImageUrl 'offline'
              }, cb

            beforeSubmit = (element, beforeData, cb) ->
              uploadFunc = (imageName, next) ->
                browser = $(".#{imageName}Upload")[0]
                if browser.files[0]?
                  submissionData =
                    formFields: beforeData[imageName]
                    file: browser.files[0]
                    error: (arg) ->
                      console.log "error submitting #{imageName} image"
                      notify.error "error submitting #{imageName} image"
                      next null, false
                    success: (args...) ->
                      console.log 'success!', args
                      next null, true
                  submitToAws submissionData
                else
                  next()

              # Do in parallel:
              async.parallel {
                logoUrl: (next) -> uploadFunc 'logo', next
                onlineUrl: (next) -> uploadFunc 'online', next
                offlineUrl: (next) -> uploadFunc 'offline', next
              }, cb

            #Done with edit/delete handlers, now render page
            $('#content').html templ websites: websites

            formBuild = formBuilder getFormFields, editWebsite, deleteWebsite, extraDataPacker, websiteRow, websites, 'website', beforeRender, beforeSubmit, embedLink

            $('#addWebsite').click formBuild.elementForm editWebsite, getNewWebsite(), 'edit', (err, savedWebsite) ->
              return notify.error "Error saving website: #{err}" if err?
              formBuild.setElement savedWebsite
              $('#websiteTableBody').append websiteRow website: savedWebsite

            #Attach handlers to all rows
            formBuild.wireUpRow website.id for website in websites
