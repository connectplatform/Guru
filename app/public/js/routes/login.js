(function() {

  define(["load/server", "load/notify", "routes/sidebar", "templates/sidebar", "helpers/util", "policy/registerSessionUpdates"], function(server, notify, sidebar, sbTemp, util, registerSessionUpdates) {
    return function(args, templ) {
      console.log("routed to login");
      $('#content').html(templ());
      $('#login-modal').modal();
      $('#login-modal #email').focus();
      $('#login-modal').on('hide', function() {
        return window.location.hash = '/';
      });
      $('#login-form').submit(function() {
        var fields;
        fields = {
          email: $('#login-form #email').val(),
          password: $('#login-form #password').val()
        };
        server.ready(function() {
          return server.login(fields, function(err, user) {
            if (err != null) return notify.error("Error logging in: " + err);
            $('#login-modal').modal('hide');
            registerSessionUpdates();
            return window.location.hash = '/dashboard';
          });
        });
        return false;
      });
      $('#login-cancel-button').click(function() {
        $('#login-modal').modal('hide');
        return window.location.hash = '/';
      });
      return $('#forgot-password-link').click(function() {
        return $('#login-modal').modal('hide');
      });
    };
  });

}).call(this);
