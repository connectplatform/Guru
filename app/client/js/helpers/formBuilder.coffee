define ['load/server', 'load/notify', 'helpers/util', 'helpers/generateChatLink'],
  (server, notify, {toTitle}, generateChatLink) ->
    (getFormFields, editingTemplate, deletingTemplate, extraDataPacker, rowTemplate, initialElements, elementName, beforeRender, beforeSubmit, embedLinkTemplate) ->

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
        elementForm: (template, element, action, onComplete) ->
          (evt) ->
            evt.preventDefault()
            beforeRender element, (beforeData) ->

              templateObject = {}
              templateObject[elementName] = element

              $("##{elementName}ModalBox").html template templateObject
              $("##{action}#{modelName}").modal()

              $("##{action}#{modelName} .saveButton").click (evt) ->
                evt.preventDefault()

                # compile fields
                beforeSubmit element, beforeData, (err, fields) ->
                  fields ||= {}
                  fields.merge getFormFields()
                  fields.id = element.id if element.id?

                  server.saveModel {modelName: modelName, fields: fields}, (err, savedElement) ->
                    return notify.error "Error saving element: #{err}" if err?
                    formBuilder.setElement savedElement

                    onComplete err, savedElement
                    return if err?

                    formBuilder.wireUpRow(savedElement.id)
                    $("##{action}#{modelName}").modal 'hide'

              $("##{action}#{modelName} .cancelButton").click (evt) ->
                evt.preventDefault()
                $("##{action}#{modelName}").modal 'hide'

        wireUpRow: (id) =>
          currentElement = getElementById id

          #Generate link for subscribers to copy and paste onto their sites
          currentElement.embedLink = generateChatLink(currentElement)

          # Event listeners/firing for embed link generator modal
          $('#editWebsite').live 'shown', ->
            $('input.linkGenerator').mouseup()
          $('input.linkGenerator').live 'mouseup', ->
            setTimeout ->
              $('input.linkGenerator').select()
            , 100

          editElementClicked = formBuilder.elementForm editingTemplate, currentElement, 'edit', (err, savedElement) ->
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

          embedLinkElementClicked = formBuilder.elementForm embedLinkTemplate, currentElement, 'embedLink', (err, data) ->
            evt.preventDefault()

          $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{id}] .edit#{modelName}").click editElementClicked
          $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{id}] .delete#{modelName}").click deleteElementClicked
          $("##{elementName}TableBody .#{elementName}Row[#{elementName}Id=#{id}] .embedLink#{modelName}").click embedLinkElementClicked

        setElement: (newElement) ->
          for element in elements
            if element.id is newElement.id
              return elements[elements.indexOf element] = extraDataPacker newElement
          elements.push newElement

      return formBuilder
