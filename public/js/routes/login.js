(function() {

  define(["app/server", "app/notify", "app/registerSessionUpdates"], function(server, notify, registerSessionUpdates) {
    return function(args, templ) {
      $('#content').html('');
      $('#content').append(templ());
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
      return $('#login-cancel-button').click(function() {
        $('#login-modal').modal('hide');
        return window.location.hash = '/';
      });
    };
  });

}).call(this);
