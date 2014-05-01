define ["load/server", "load/notify"], (server, notify) ->
  (_, templ, queryString={}) ->
    {uid, regkey} = queryString

    $('#content').html templ()

    server.ready ->
      $(".reset-password-form").submit (evt) ->
        evt.preventDefault()

        #scrape and clear form, disable button
        $(".submit-button").attr("disabled", "disabled")
        newPassword = $("#newPassword").val()
        passwordConfirm = $("#newPasswordConfirmation").val()

        unless newPassword is passwordConfirm
          $(".submit-button").removeAttr("disabled")
          notify.error "Passwords do not match"
          return

        server.resetPassword {userId: uid, registrationKey: regkey, newPassword: newPassword}, (err) ->
          if err?
            $(".submit-button").removeAttr("disabled")
            notify.error "Error changing password: #{err}" if err?
          else
            notify.success "Password changed.  You may now log in!"
            window.location.hash = '/'
