define ["load/server", "load/notify", 'helpers/util'], (server, notify, util) ->
  {getDomain} = util

  (_, templ, queryParams={}) ->
    $("#content").html "Loading..."
    delete queryParams["undefined"]

    #fall back to referrer if queryParams doesn't give us the website we came from
    unless queryParams.websiteUrl
      queryParams.websiteUrl = getDomain document.referrer

    server.ready ->

      # redirect if already a chat for this session
      server.getExistingChat (err, data) ->
        console.log "Error getting existing chat:", err if err?
        return window.location.hash = "/visitorChat/#{data.chatId}" if data?.chatId

        # redirect if we have enough data from query params
        server.createChatOrGetForm queryParams, (err, result) ->
          console.log "Error getting chat result:", err if err?
          return window.location.hash = "/visitorChat/#{result.chatId}" if result?.chatId
          #TODO: show website selector if no website present

          # otherwise render the user data form
          $("#content").html templ result
          $("#newChat-form").find(':input').filter(':visible:first')

          $("#newChat-form").submit (evt) ->
            evt.preventDefault()

            toObj = (obj, item) ->
              obj[item.name] = item.value
              return obj
            formParams = $(@).serializeArray().reduce toObj, {}

            server.newChat queryParams.merge(formParams), (err, data) ->
              console.log 'got new chat'
              if err?
                $("#content").html templ result
                notify.error "Error connecting to chat: #{err}"

              else
                window.location.hash = "/visitorChat/#{data.chatId}"

            $("#content").html "Connecting to chat..."
