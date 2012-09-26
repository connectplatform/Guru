(function() {
  var setLogoffOnPageExit;

  setLogoffOnPageExit = function(server) {
    console.log("logoff set");
    return $(window).unload(function() {
      var sessionId;
      sessionId = server.cookie('session');
      server.cookie('session', null);
      console.log("cookie after unload: ", server.cookie('session'));
      return server.setSessionOffline(sessionId, function() {});
    });
  };

  define(["load/server", "load/notify", "routes/sidebar", "templates/sidebar", "helpers/util", "policy/registerSessionUpdates"], function(server, notify, sidebar, sbTemp, util, registerSessionUpdates) {
    return function(args, templ) {
      console.log("routed to login");
      $('#content').html(templ());
      $('#login-modal').modal();
      $('#login-modal #email').focus();
      $('#login-modal').on('hide', function() {
        return window.location.hash = '/';
      });
      $('#login-form').submit(function(evt) {
        var fields;
        evt.preventDefault();
        fields = {
          email: $('#login-form #email').val(),
          password: $('#login-form #password').val()
        };
        return server.ready(function() {
          return server.login(fields, function(err, user) {
            if (err != null) return notify.error("Error logging in: " + err);
            $('#login-modal').modal('hide');
            registerSessionUpdates();
            setLogoffOnPageExit(server);
            return window.location.hash = '/dashboard';
          });
        });
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
