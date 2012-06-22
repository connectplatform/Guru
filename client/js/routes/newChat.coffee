define ["guru/server", "guru/notify"], (server, notify) ->
  (_, templ) ->
    $("#content").html "Loading..."
    server.ready ->
      $("#content").html templ()
      $("#newChat-form #username").focus()

      $("#newChat-form").submit ->

        username = $("#newChat-form #username").val()
        server.cookie 'username', username

        server.newChat username: username, (err, data) ->
          if err?
            $("#content").html templ()
            notify.error "Error logging in: #{err}"

          else
            window.location.hash = "/visitorChat/#{data.channel}"

        $("#content").html "Connecting to chat..."
        false
