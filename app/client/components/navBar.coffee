define ['flight/component', 'templates/components/navBar'],
  (defineComponent, templ) ->
    navBar = () ->

      @after 'initialize', () ->

        @attr.collector.register()

        @attr.collector.ready () =>

          # render template to DOM if it doesn't exist
          # QUESTION -- is this idiomatic jquery?
          if $('.navbar').length == 0
            @$node.append (templ {
              role: @attr.role
              appName: @attr.appName
              username: @attr.models?.mySession?[0]?.username
            })

          # AD HOC -- data-blind UIX scripting should separated
          # highlight the active route
          $('.nav li').click () ->
            $('.nav li').removeClass 'active'
            $this = $(this)
            $this.addClass 'active' unless $this.hasClass 'active'

          # process initial payload data
          {
            unansweredChats
            unreadMessages
          } = @attr.models.mySession

          # AD HOC -- should be part of a lifecycle step
          $('.notifyUnanswered').text unansweredChats
          $('.notifyUnread').text unreadMessages

          # TODO: this should come from a cache source
          # $('#notifyInvites')

          @attr.QueryProxy @node,
                           @attr.collector,
                           @attr.queryProxyConfig

    return defineComponent(navBar)
