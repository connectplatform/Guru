define ["load/server", "load/notify", 'helpers/util'], (server, notify, util) ->
  {getDomain} = util
  (_, templ, queryString={}) ->
    $("#content").html "Loading..."
    delete queryString["undefined"]

    server.ready ->

      server.getExistingChatChannel (err, data) ->
        window.location.hash = "/visitorChat/#{data.channel}" if data

        $("#content").html templ()
        $("#newChat-form #username").focus()
        $("#newChat-form").submit (evt) ->
          evt.preventDefault()

          username = $("#newChat-form #username").val()

          #fall back to referrer if queryString doesn't give us the website we came from
          unless queryString.websiteUrl
            queryString.websiteUrl = getDomain document.referrer

          server.newChat {username: username, params: queryString}, (err, data) ->
            if err?
              $("#content").html templ()
              notify.error "Error connecting to chat: #{err}"

            else
              window.location.hash = "/visitorChat/#{data.chatId}"

          $("#content").html "Connecting to chat..."
