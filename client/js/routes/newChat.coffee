define ["guru/server", "guru/notify"], (server, notify) ->
  (_, templ) ->
    $("#content").html "Loading..."
    server.ready ->

      server.shouldReconnectToChat (err, data)->
        window.location.hash = "/visitorChat/#{data.channel}" if data?

        $("#content").html templ()
        $("#newChat-form #username").focus()

        $("#newChat-form").submit ->

          username = $("#newChat-form #username").val()
          server.cookie 'username', username

          server.newChat username: username, (err, data) ->
            console.log "data: #{data}"
            if err?
              $("#content").html templ()
              notify.error "Error connecting to chat: #{err}"

            else
              window.location.hash = "/visitorChat/#{data.channel}"

          $("#content").html "Connecting to chat..."
          false