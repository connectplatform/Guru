define ['flight/component', 'templates/components/navBar'],
  (defineComponent, templ) ->
    navBar = ->

      @after 'initialize', ->
        console.log '[DEBUG] initialize'

        # apply the template to the DOM if doesn't exist
        applyTemplate = () =>
          if $('.navbar').length == 0
            console.log '[DEBUG] applying template.*'
            console.log '@attr.models', @attr.models
            @$node.append templ(
              role: @attr.role
              appName: @attr.appName
              username: @attr.models.mySession?[0]?.username
            )

          # highlight the active route
          $('.nav li').click () ->
            $('.nav li').removeClass 'active'
            $this = $(this)
            $this.addClass 'active' unless $this.hasClass 'active'

        @attr.collector.on 'mySession.unansweredChats', (data, event) =>
          # console.log 'event!:', JSON.stringify {data, event}
          $('.notifyUnanswered').text event.data

        # @attr.collector.on 'myData.*', (data, event) =>
        #   console.log '[DEBUG] myData.*'
        #   console.log '[myData.* (event)]', JSON.stringify event
        #   console.log '[myData.* (data)]', JSON.stringify data

        #   # TODO: factor out into processEvent function
        #   switch event.path
        #     when 'unansweredChats'
        #       $('.notifyUnanswered').text event.data
        #     when 'unreadMessages'
        #       $('.notifyUnread').text event.data
        #     when 'username'
        #       $('.username').text event.data

        @attr.collector.ready () =>
          console.log '[DEBUG] ready'

          @attr.models = @attr.collector?.data
          console.log JSON.stringify {'@attr.models': @attr.models}

          # s = JSON.stringify @attr.collector.data
          # console.log '@attr.collector.data', s

          applyTemplate()

          # process initial payload data
          {unansweredChats} = @attr.models.mySession
          {unreadMessages} = @attr.models.mySession
          $('.notifyUnanswered').text unansweredChats
          $('.notifyUnread').text unreadMessages

          # TODO: this should come from a cache source
          # $('#notifyInvites')

        @attr.collector.register()

        # for debugging only, make models accessible in browser console
        # window.models = @attr.models

    return defineComponent(navBar)
