define ["flight/component", 'templates/components/cannedResponse'],
  (defineComponent, cannedResponseTempl) ->
    acpData = ->

      @after "initialize", ->
        console.log {particleModels: @attr.models}

        # apply the template to the DOM if doesn't exist
        if $('.cannedResponseArea').length == 0
          @$node.append cannedResponseTempl

    return defineComponent(cannedResponse)