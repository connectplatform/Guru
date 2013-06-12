define ["flight/component", 'templates/components/navBar'],
  (defineComponent, templ) ->
    navBar = ->

      @after "initialize", ->
        console.log {particleModels: @attr.models}

        # apply the template to the DOM if doesn't exist
        if $('.navbar').length == 0
          @$node.append templ(role: @attr.role, appName: @attr.appName, username: 'Monad')

        $(".nav li").click () ->
          $(".nav li").removeClass "active"
          $this = $(this)
          $this.addClass "active" unless $this.hasClass("active")

    return defineComponent(navBar)
