define ["app/server", "app/notify", "app/pulsar", 'templates/badge'], (server, notify, pulsar, badge) ->
  (args, templ) ->
    $('#sidebar').html templ()

    updates = pulsar.channel 'notify:operators'
    updates.on 'unansweredCount', (num) ->
      console.log "#{num} unanswered chats."
      content = if num > 0 then badge {num: num} else ''
      $("#notifyUnanswered").html content
