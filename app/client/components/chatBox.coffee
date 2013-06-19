define ["flight/component", 'templates/components/chatBox'],
  (defineComponent, chatBoxTempl) ->
    chatBox = ->

      @after "initialize", ->
        console.log {particleModels: @attr.models}

        # apply the template to the DOM if doesn't exist
        if $('.topOfChatboxDiv').length == 0
          @$node.append chatBoxTempl


    return defineComponent(chatBox)