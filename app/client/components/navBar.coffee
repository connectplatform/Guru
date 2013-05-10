"use strict"
define ["load/server", "load/notify", "load/pulsar", "flight/component", 'helpers/sidebarHelpers', 'templates/navBar', 'js/vendor/flight/lib/utils', 'js/vendor/flight/lib/registry', 'app/config'], (server, notify, pulsar, defineComponent, helpers, templ, utils, registry, config) ->
  navBar = ->
    

    @after "initialize", ->

      # apply the template to the DOM if doesn't exist
      if $('.navbar').length == 0
        @$node.append templ(role: @attr.role, name: config.name)
        #@$node.append templ role: @attr.role
 
      $(".nav li").click () ->
        $(".nav li").removeClass "active"
        $this = $(this)
        $this.addClass "active"  unless $this.hasClass("active")


  return defineComponent(navBar)