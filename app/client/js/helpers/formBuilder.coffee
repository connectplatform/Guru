define ['load/server', 'load/notify'], (server, notify) ->
  (getFormFields, editingTemplate, deletingTemplate, extraDataPacker, rowTemplate, initialElements, elementName, beforeRender, beforeSubmit)->
    unless beforeRender?
      beforeRender = (_, cb) -> cb {}

    unless beforeSubmit?
      beforeSubmit = (_, __, cb) -> cb()

    uppercaseName = elementName.charAt(0).toUpperCase() + elementName.slice(1)

    elements = initialElements

    getElementById = (id) ->
      for element in elements
        if element.id is id
          return extraDataPacker element

    formBuilder =
      elementForm: (template, element, onComplete) ->
        (evt) ->
          evt.preventDefault()
          beforeRender element, (beforeData) ->

            templateObject = {}
            templateObject[elementName] = element

            $("##{elementName}ModalBox").html template templateObject
            $("#edit#{uppercaseName}").modal()

            $("#edit#{uppercaseName} .saveButton").click (evt) ->
              evt.preventDefault()
              console.log 'ping'

              beforeSubmit element, beforeData, ->

                fields = getFormFields()

                #Get modelName based on availiable fields in form,
                #TODO: help fixing this, maybe some meta data from the form or something
                if fields.role then modelName = 'User'
                else if fields.acpApiKey then modelName = 'Website'
                else modelName = 'Specialty'

                fields.id = element.id if element.id?

                server.saveModel {modelName: modelName, fields: fields, uppercaseName: uppercaseName}, (err, savedElement) ->
                  return notify.error "Error saving element: #{err}" if err?
                  formBuilder.setElement savedElement

                  onComplete err, savedElement
                  return if err?

                  formBuilder.wireUpRow(savedElement.id)
                  $("#edit#{uppercaseName}").modal 'hide'

            $("#edit#{uppercaseName} .cancelButton").click (evt) ->
              evt.preventDefault()
              $("#edit#{uppercaseName}").modal 'hide'

      wireUpRow: (id) =>
        currentElement = getElementById id

        editElementClicked = formBuilder.elementForm editingTemplate, currentElement, (err, savedElement) ->
          #return notify.error "Error saving element: #{err}" if err?

          templateObject = {}
          templateObject[elementName] = savedElement
          $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{currentElement.id}]").replaceWith rowTemplate templateObject

        deleteElementClicked = (evt) ->
          evt.preventDefault()
          currentElement = getElementById $(this).attr "#{elementName}Id"

          templateObject = {}
          templateObject[elementName] = currentElement
          $("##{elementName}ModalBox").html deletingTemplate templateObject
          $("#delete#{uppercaseName}").modal()

          $("#delete#{uppercaseName} .deleteButton").click (evt) ->
            evt.preventDefault()

            server.deleteModel {modelId: currentElement.id, modelName: uppercaseName}, (err) ->
              return notify.error "Error deleting #{elementName}: #{err}" if err?
              $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{currentElement.id}]").remove()
              $("#delete#{uppercaseName}").modal 'hide'

          $("#delete#{uppercaseName} .cancelButton").click ->
            $("#delete#{uppercaseName}").modal 'hide'

        $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{id}] .edit#{uppercaseName}").click editElementClicked
        $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{id}] .delete#{uppercaseName}").click deleteElementClicked

      addElement: (newElement, cb) ->
        (evt) ->
          formBuilder.elementForm editingTemplate, newElement, (err, savedElement) ->
            initialElements.push savedElement unless err
            cb err, savedElement

      setElement: (newElement) ->
        for element in elements
          if element.id is newElement.id
            return elements[elements.indexOf element] = extraDataPacker newElement
        elements.push newElement

    return formBuilder
