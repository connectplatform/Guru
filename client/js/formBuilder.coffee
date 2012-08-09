define [], ->
  (getFormFields, editingTemplate, deletingTemplate, saveService, deleteService, extraDataPacker, rowTemplate, initialElements)->

    elements = initialElements

    getElementById = (id) ->
      for element in elements
        if element.id is id
          return extraDataPacker element

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

            saveService fields, (err, savedUser) ->
              formBuilder.setElement savedUser
              console.log "savedUser", savedUser
              console.log "element is now", getElementById savedUser.id

              onComplete err, savedUser
              return if err?

              formBuilder.wireUpRow(savedUser.id)
              $('#editUser').modal 'hide'

          $('#editUser .cancelButton').click (evt) ->
            evt.preventDefault()
            $('#editUser').modal 'hide'

      wireUpRow: (id) =>
        currentUser = getElementById id

        editUserClicked = formBuilder.userForm editingTemplate, currentUser, (err, savedUser) ->

          console.log "currentUser", currentUser
          console.log "savedUser", savedUser

          return notify.error "Error saving user: #{err}" if err?
          $("#userTableBody .userRow[userId=#{currentUser.id}]").replaceWith rowTemplate user: savedUser

        deleteUserClicked = (evt) ->
          evt.preventDefault()
          currentUser = getElementById $(this).attr 'userId'

          console.log "currentUser", currentUser
          $("#modalBox").html deletingTemplate user: currentUser
          console.log "box rendered"
          $('#deleteUser').modal()

          $('#deleteUser .deleteButton').click (evt) ->
            evt.preventDefault()

            deleteService currentUser.id, (err) ->
              return notify.error "Error deleting user: #{err}" if err?
              $("#userTableBody .userRow[userId=#{currentUser.id}]").remove()
              $('#deleteUser').modal 'hide'

          $('#deleteUser .cancelButton').click ->
            $('#deleteUser').modal 'hide'

        $("#userTableBody .userRow[userId=#{id}] .editUser").click editUserClicked
        $("#userTableBody .userRow[userId=#{id}] .deleteUser").click deleteUserClicked

      addElement: (newElement, cb) ->
        (evt) ->
          formBuilder.userForm editingTemplate, newElement, (err, savedElement) ->
            initialElements.push savedUser unless err
            cb err, savedElement

      setElement: (newElement) ->
        for element in elements
          if element.id is newElement.id
            return elements[elements.indexOf element] = extraDataPacker newElement
        elements.push newElement

    return formBuilder
