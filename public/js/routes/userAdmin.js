(function() {

  define(["app/server", "app/notify"], function(server, notify) {
    return function(_, templ) {
      $('#content').html(templ());
      return server.ready(function() {
        return $(".password-change-form").submit(function(evt) {
          var newPassword, oldPassword, passwordConfirm;
          console.log("form submitted");
          evt.preventDefault();
          $(".submit-button").attr("disabled", "disabled");
          oldPassword = $("#oldPassword").val();
          newPassword = $("#newPassword").val();
          passwordConfirm = $("#newPasswordConfirmation").val();
          $("#oldPassword").val("");
          $("#newPassword").val("");
          $("#newPasswordConfirmation").val("");
          if (newPassword !== passwordConfirm) {
            console.log("passwords don't match");
            $(".submit-button").removeAttr("disabled");
            notify.error("Passwords do not match");
            return;
          }
          return server.changePassword(oldPassword, newPassword, function(err) {
            $(".submit-button").removeAttr("disabled");
            if (err != null) {
              if (err != null) {
                return notify.error("Error changing password: " + err);
              }
            } else {
              return notify.success("Password changed successfully");
            }
          });
        });
      });
    };
  });

}).call(this);
