define ['templates/enterEmail', 'load/server', 'load/notify'], (enterEmail, server, notify) ->
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
                error: err,
                severity: 'warn',
                email: email, ->
              notify.error 'Error sending email: ', err
            else
              notify.success 'Email sent'
