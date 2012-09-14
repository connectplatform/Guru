(function() {

  define(["load/server", "load/notify"], function(server, notify) {
    return function(_, templ, queryString) {
      var regkey, uid;
      if (queryString == null) queryString = {};
      uid = queryString.uid, regkey = queryString.regkey;
      $('#content').html(templ());
      return server.ready(function() {
        return $(".password-change-form").submit(function(evt) {
          var newPassword, passwordConfirm;
          evt.preventDefault();
          $(".submit-button").attr("disabled", "disabled");
          newPassword = $("#newPassword").val();
          passwordConfirm = $("#newPasswordConfirmation").val();
          if (newPassword !== passwordConfirm) {
            $(".submit-button").removeAttr("disabled");
            notify.error("Passwords do not match");
            return;
          }
          return server.resetPassword(uid, regkey, newPassword, function(err) {
            if (err != null) {
              $(".submit-button").removeAttr("disabled");
              if (err != null) {
                return notify.error("Error changing password: " + err);
              }
            } else {
              notify.success("Password changed.  You may now log in!");
              return window.location.hash = '/';
            }
          });
        });
      });
    };
  });

}).call(this);
