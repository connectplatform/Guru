"use strict"
define ["load/server", "load/notify", "load/pulsar", "flight/component"] (server, notify, pulsar, defineComponent) ->
  operatorChat = ->

    @after "initialize", ->

      #adds Template if does not exist in DOM
      if $('#chatWrapper').length == 0
        @$node.append templ

      #tests component's firing
      console.log "operatorChat Component"

  return defineComponent(operatorChat)
