define ["flight/component", 'templates/components/navBar', 'js/vendor/flight/lib/utils', 'js/vendor/flight/lib/registry', 'app/config'], (defineComponent, templ, utils, registry, config) ->
  navBar = ->

    @after "initialize", ->

      # apply the template to the DOM if doesn't exist
      if $('.navbar').length == 0
        @$node.append templ(role: @attr.role, name: config.name)

      $(".nav li").click () ->
        $(".nav li").removeClass "active"
        $this = $(this)
        $this.addClass "active" unless $this.hasClass("active")


  return defineComponent(navBar)
