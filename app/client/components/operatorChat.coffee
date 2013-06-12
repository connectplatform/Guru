define ["load/server", "load/notify", "flight/component"],
  (server, notify, defineComponent) ->
    operatorChat = ->

      @after "initialize", ->

        #adds Template if does not exist in DOM
        if $('#chatWrapper').length == 0
          @$node.append templ

        #tests component's firing
        console.log "operatorChat Component"

    return defineComponent(operatorChat)

# required jqueryui dependencies, will merge into component later
#$ ->
  #$(".chatboxSlider").slider
    #orientation: "vertical"
    #range: "max"
    #min: 0
    #max: 100
    #value: 88
    #slide: (event, ui) ->
      #$("#amount").val ui.value
