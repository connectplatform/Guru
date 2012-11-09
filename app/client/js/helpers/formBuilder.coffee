define ['load/server', 'load/notify', 'helpers/util'], (server, notify, {toTitle}) ->
  (getFormFields, editingTemplate, deletingTemplate, extraDataPacker, rowTemplate, initialElements, elementName, beforeRender, beforeSubmit) ->

    unless beforeRender?
      beforeRender = (_, cb) -> cb {}

    unless beforeSubmit?
      beforeSubmit = (_, __, cb) -> cb()

    modelName = toTitle elementName

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
            $("#edit#{modelName}").modal()

            $("#edit#{modelName} .saveButton").click (evt) ->
              evt.preventDefault()
              console.log 'ping'

              beforeSubmit element, beforeData, ->

                fields = getFormFields()

                fields.id = element.id if element.id?

                server.saveModel {modelName: modelName, fields: fields}, (err, savedElement) ->
                  return notify.error "Error saving element: #{err}" if err?
                  formBuilder.setElement savedElement

                  onComplete err, savedElement
                  return if err?

                  formBuilder.wireUpRow(savedElement.id)
                  $("#edit#{modelName}").modal 'hide'

            $("#edit#{modelName} .cancelButton").click (evt) ->
              evt.preventDefault()
              $("#edit#{modelName}").modal 'hide'

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
          $("#delete#{modelName}").modal()

          $("#delete#{modelName} .deleteButton").click (evt) ->
            evt.preventDefault()

            server.deleteModel {modelId: currentElement.id, modelName: modelName}, (err) ->
              return notify.error "Error deleting #{elementName}: #{err}" if err?
              $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{currentElement.id}]").remove()
              $("#delete#{modelName}").modal 'hide'

          $("#delete#{modelName} .cancelButton").click ->
            $("#delete#{modelName}").modal 'hide'

        $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{id}] .edit#{modelName}").click editElementClicked
        $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{id}] .delete#{modelName}").click deleteElementClicked

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
