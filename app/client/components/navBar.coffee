define ['flight/component', 'templates/components/navBar', 'load/render'],
  (defineComponent, templ, render) ->

    navBar = () ->

      @after 'initialize', () ->

        @attr.collector.register()

        prepareUI = () =>
          if $('.navbar').length is 0
            $(@node).append (templ {
              role: @attr.role
              appName: @attr.appName
              username: @attr.models?.mySession?[0]?.username
            })

          $('.nav li').click () ->
            $('.nav li').removeClass 'active'
            $this = $(this)
            $this.addClass 'active' unless $this.hasClass 'active'

          # process initial payload data
          {
            unansweredChats
            unreadMessages
          } = @attr.models.mySession

          $('.notifyUnanswered').html unansweredChats
          $('.notifyUnread').html unreadMessages

          # TODO: this should come from a cache source
          # $('#notifyInvites')

        @attr.collector.ready prepareUI

        @attr.queryProxy.on 'unansweredChats', (data) =>
          sel = $(@node).find('.notifyUnanswered')
          templ = (data) ->
            return "" unless data?.unansweredChats > 0
            return "#{data?.unansweredChats}"

          render.replace sel, templ, data

        @attr.queryProxy.on 'unreadMessages', (data) =>
          sel = $(@node).find('.notifyUnread')
          templ = (data) ->
            return "" unless data?.unreadMessages > 0
            return "#{data?.unreadMessages}"

          render.replace sel, templ, data


    return defineComponent(navBar)
