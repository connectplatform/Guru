define ["load/server"], (server) ->
  (getFormFields, editingTemplate, deletingTemplate, extraDataPacker, rowTemplate, initialElements, elementName)->

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

          templateObject = {}
          templateObject[elementName] = element

          $("##{elementName}ModalBox").html template templateObject
          $("#edit#{uppercaseName}").modal()

          $("#edit#{uppercaseName} .saveButton").click (evt) ->
            evt.preventDefault()

            fields = getFormFields()
            fields.id = element.id if element.id?

            server.saveModel fields, uppercaseName, (err, savedElement) ->
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

          return notify.error "Error saving element: #{err}" if err?
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

            server.deleteModel currentElement.id, uppercaseName, (err) ->
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
