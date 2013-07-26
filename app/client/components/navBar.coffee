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
              username: @attr.models.session?.username
            )
  
          $('.nav li').click () ->
            $('.nav li').removeClass 'active'
            $this = $(this)
            $this.addClass 'active' unless $this.hasClass 'active'

        @attr.collector.on 'myData.*', (data, event) =>
          console.log '[DEBUG] myData.*'
          console.log 'myData.* (event)', JSON.stringify event
          console.log 'myData.* (data)', JSON.stringify data

        @attr.collector.ready () =>
          console.log '[DEBUG] ready'
          @attr.models = @attr.collector?.data?.myData?[0]
          s = JSON.stringify @attr.collector.data
          console.log '@attr.collector.data', s

          applyTemplate()
          
          {unansweredChats} = @attr.models.session
          {unreadMessages} = @attr.models.session
          console.log {unansweredChats, unreadMessages}
          $('.notifyUnanswered').text unansweredChats
          # $('#notifyInvites')
          $('.notifyUnread').text unreadMessages
          
        @attr.collector.register()

        # for debugging only
        # window.models = @attr.models



    return defineComponent(navBar)
