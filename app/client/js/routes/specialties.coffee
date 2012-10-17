define ["load/server", "load/notify", "templates/editSpecialty", "templates/deleteSpecialty", "templates/specialtyRow", "helpers/formBuilder"],
  (server, notify, editSpecialty, deleteSpecialty, specialtyRow, formBuilder) ->
    (args, templ) ->
      return window.location.hash = '/' unless server.cookie 'session'

      server.ready ->

        getFormFields = ->
          {
            name: $('#editSpecialty .name').val()
          }

        getNewSpecialty = ->
          {
            name: ""
          }

        extraDataPacker = (specialty) -> return specialty

        # find all specialties and populate listing
        server.findModel {}, "Specialty", (err, specialties) ->
          server.log 'Error retrieving specialties on specialties crud page', {error: err, severity: 'error'} if err

          formBuild = formBuilder getFormFields, editSpecialty, deleteSpecialty, extraDataPacker, specialtyRow, specialties, "specialty"
          #Done with edit/delete handlers, now render page
          $('#content').html templ specialties: specialties

          $('#addSpecialty').click formBuild.elementForm editSpecialty, getNewSpecialty(), (err, savedSpecialty) ->
            return notify.error "Error saving specialty: #{err}" if err?
            formBuild.setElement savedSpecialty
            $("#specialtyTableBody").append specialtyRow specialty: savedSpecialty

          #Attach handlers to all rows
          formBuild.wireUpRow specialty.id for specialty in specialties
