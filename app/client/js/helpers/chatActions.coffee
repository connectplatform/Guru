define ['templates/enterEmail', 'load/server', 'load/notify'], (enterEmail, server, notify) ->

  sendChatMessage: (channel, renderedId=null) ->
    msgSelector = if renderedId then $("##{renderedId} .message") else $(".message")
    message = msgSelector.val()

    unless message is ""
      lines = message.split(/\r\n|\r|\n/g)

      channel.emit 'clientMessage',
        message: lines
        session: server.cookie 'session'
        timestamp: new Date().getTime()

      msgSelector.val("")

      # this timeout allows the broken scroll to occur, wherever it's happening,
      # I cant find it, and then we correct it to the scrollHeight. Terrible hack.
      setTimeout ->
        $(".chat-display-box").scrollTop($(".chat-display-box")[0].scrollHeight)
      , 66

  print: (chatId) ->
    (evt) ->
      evt.preventDefault()
      location = "https://#{window.location.host}/#/printChat/#{chatId}"
      window.open location

  email: (chatId) ->
    (evt) ->
      evt.preventDefault()
      $("#selectModal").html enterEmail()
      $("#enterEmail").modal()

      $(".enterEmailForm").submit (evt) ->
        evt.preventDefault()
        email = $('#enterEmail .email').val()

        $("#enterEmail").modal "hide"
        server.ready ->
          server.emailChat {chatId: chatId, email: email}, (err, response) ->
            if err
              server.log
                message: 'Error sending email',
                context:
                  error: err,
                  severity: 'warn',
                  email: email

              notify.error 'Error sending email: ', err
            else
              notify.success 'Email sent'
