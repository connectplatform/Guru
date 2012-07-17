define ["app/server", "app/notify", "app/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->
    $('#sidebar').html templ()

    updates = pulsar.channel 'notify:operators'

    # call to update badge number
    updateUnanswered = (num) ->
      content = if num > 0 then badge {status: 'important', num: num} else ''
      $(".notifyUnanswered").html content

    # init badge number
    server.ready ->

      # TODO: move this to 'before' middleware
      server.getMyRole (err, role) ->
        unless role in ['Operator', 'Supervisor', 'Administrator']
          window.location.hash = '#/logout'

        else
          server.getChatStats (err, stats) ->
            updateUnanswered stats.unanswered.length

          # update badge number on change
          updates.on 'unansweredCount', updateUnanswered

          # TODO: move this to 'after' middleware
          $(window).bind 'hashchange', ->
            updates.removeAllListeners 'unansweredCount'
