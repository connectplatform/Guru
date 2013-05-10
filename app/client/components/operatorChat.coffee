"use strict"
define ["flight/component"], (defineComponent) ->
  operatorChat = ->
    

    @after "initialize", ->
      console.log "component"
     
 
  return defineComponent(operatorChat) 