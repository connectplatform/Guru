define ['templates/enterEmail', 'load/server', 'load/notify', 'app/config'], (enterEmail, server, notify, config) ->

  sendChatMessage: (channel, renderedId=null) ->
    msgSelector = if renderedId then $("##{renderedId} .message") else $(".message")
    message = msgSelector.val()

    unless message is ""
      lines = message.split(/\r\n|\r|\n/g)

      channel.emit 'clientMessage',
        message: lines
        session: $.cookies.get 'session'
        timestamp: new Date().getTime()

      msgSelector.val("")
      $(".chat-display-box").scrollTop($(".chat-display-box")[0].scrollHeight)

  print: (chatId) ->
    (evt) ->
      evt.preventDefault()
      location = "#{config.url}#/printChat/#{chatId}"
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
              notify.success "Email sent to #{email}."
