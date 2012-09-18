(function() {

  define(["load/server", "load/notify"], function(server, notify) {
    return function(args, templ) {
      $('#content').html(templ());
      return server.ready(function() {
        $('#forgot-password-form').submit(function(evt) {
          var email;
          evt.preventDefault();
          email = $('#forgot-password-form #email').val();
          if (email) {
            return server.forgotPassword(email, function(err, status) {
              if (err != null) {
                return notify.error("Error: " + err);
              } else {
                notify.info(status);
                return window.location.hash = '/';
              }
            });
          } else {
            return notify.error('Please enter an email.');
          }
        });
        return $('#forgot-password-form .cancel-button').click(function(evt) {
          evt.preventDefault();
          return window.location.hash = '/';
        });
      });
    };
  });

}).call(this);