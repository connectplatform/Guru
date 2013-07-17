define ["load/server", "load/notify", "flight/component", 'vendor/EventEmitter2', "components/chatBox", "components/acpData", "components/cannedResponse"],
  (server, notify, defineComponent, EventEmitter2, chatBox, acpData, cannedResponse) ->
    operatorChat = ->

      @after "initialize", ->

        #adds Template if does not exist in DOM
        if $('#chatWrapper').length == 0
          @$node.append templ

        #tests component's firing
        console.log "operatorChat Component"
      

      
        routeEvents = new EventEmitter2()

        setup:
          (args, templ, query) ->
            chatBox.attachTo '#content', {routeEvents: routeEvents}

        teardown:
          (cb) ->
            routeEvents.emit 'teardown'
            cb()


        setup:
          (args, templ, query) ->
            acpData.attachTo '#content', {routeEvents: routeEvents}

        teardown:
          (cb) ->
            routeEvents.emit 'teardown'
            cb()

        setup:
          (args, templ, query) ->
            cannedResponse.attachTo '#content', {routeEvents: routeEvents}

        teardown:
          (cb) ->
            routeEvents.emit 'teardown'
            cb()

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
