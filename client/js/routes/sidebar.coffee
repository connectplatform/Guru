define ["app/server", "app/notify", "app/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->
    $('#sidebar').html templ()

    updates = pulsar.channel 'notify:operators'

    # call to update badge number
    updateUnanswered = (num) ->
      content = if num > 0 then badge {num: num} else ''
      $(".notifyUnanswered").html content

    # init badge number
    server.ready ->
      server.getChatStats (err, stats) ->
        console.log 'got an err:', err
        updateUnanswered stats.unanswered.length

    # update badge number on change
    updates.on 'unansweredCount', updateUnanswered
