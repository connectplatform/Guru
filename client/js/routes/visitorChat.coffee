define ["guru/server", "templates/newChat"], (server, newChat) ->
  ({id}, templ) ->
    $("#content").html templ()

    server.refresh (services)->
      console.log "services: #{services}"
      $("#message-form").submit ->
        message = $("#message").val()
        server[id] message, (err, data) ->
          console.log err if err and console?
        false

      server.subscribe[id] (err, data)->
        $("#displayBox").append "<p>#{data.username}: #{data.message}</p>"