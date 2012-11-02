define ["load/server", "load/notify"], (server, notify) ->
  (args, templ) ->
    $('#content').html templ()

    server.ready ->

      $('#forgot-password-form').submit (evt) ->
        evt.preventDefault()

        email = $('#forgot-password-form #email').val()

        if email

          server.forgotPassword {email: email}, (err, status) ->
            if err?
              return notify.error "Error: #{err}"
            else
              notify.info status
              window.location.hash = '/'

        else
          notify.error 'Please enter an email.'

      $('#forgot-password-form .cancel-button').click (evt) ->
        evt.preventDefault()
        window.location.hash = '/'
