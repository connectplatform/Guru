define ["flight/component", 'templates/components/acpData'],
  (defineComponent, acpDataTempl) ->
    acpData = ->

      @after "initialize", ->
        console.log {particleModels: @attr.models}

        # apply the template to the DOM if doesn't exist
        if $('.acpDataContainer').length == 0
          @$node.append acpDataTempl


    return defineComponent(acpData)