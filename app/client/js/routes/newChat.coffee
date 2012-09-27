define ["load/server", "load/notify"], (server, notify) ->
  (_, templ, queryString={}) ->
    $("#content").html "Loading..."
    server.ready ->
      delete queryString["undefined"]

      server.getExistingChatChannel (err, data) ->
        window.location.hash = "/visitorChat/#{data.channel}" if data? and !!data

        $("#content").html templ()
        $("#newChat-form #username").focus()
        $("#newChat-form").submit (evt) ->
          evt.preventDefault()

          username = $("#newChat-form #username").val()

          #fall back to referrer if queryString doesn't give us the website we came from
          unless queryString.websiteUrl
            referrer = document.referrer or ""
            referrerArray = referrer.split "/"
            queryString.websiteUrl = referrerArray[0] + referrerArray[1] + referrerArray[2] if referrerArray.length >= 2
          server.newChat {username: username, referrerData: queryString}, (err, chat) ->
            if err?
              $("#content").html templ()
              notify.error "Error connecting to chat: #{err}"

            else
              window.location.hash = "/visitorChat/#{chat.chatId}"

          $("#content").html "Connecting to chat..."
