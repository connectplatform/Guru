define ["app/server", "app/notify"], (server, notify) ->
  (_, templ) ->
    $('#content').html templ()
    server.ready ->
      $(".password-change-form").submit (evt) ->
        console.log "form submitted"
        evt.preventDefault()

        #scrape and clear form, disable button
        $(".submit-button").attr("disabled", "disabled")
        oldPassword = $("#oldPassword").val()
        newPassword = $("#newPassword").val()
        passwordConfirm = $("#newPasswordConfirmation").val()
        $("#oldPassword").val ""
        $("#newPassword").val ""
        $("#newPasswordConfirmation").val ""

        unless newPassword is passwordConfirm
          console.log "passwords don't match"
          $(".submit-button").removeAttr("disabled")
          notify.error "Passwords do not match"
          return

        server.changePassword oldPassword, newPassword, (err) ->
          $(".submit-button").removeAttr("disabled")
          if err?
            notify.error "Error changing password: #{err}" if err?
          else
            notify.success "Password changed successfully"

