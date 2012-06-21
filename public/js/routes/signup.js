// Generated by CoffeeScript 1.3.1
(function() {

  define(["destiny/server", "destiny/notify", "templates/signup"], function(server, notify, templ) {
    return function() {
      $('#content').append(templ());
      $('#signup-modal').modal();
      $('#signup-modal #first').focus();
      $('#signup-modal').on('hide', function() {
        return window.location.hash = '#/';
      });
      $('#signup-form').submit(function() {
        var fields;
        fields = {
          first: $('#signup-modal #first').val(),
          last: $('#signup-modal #last').val(),
          email: $('#signup-modal #email').val(),
          password: $('#signup-modal #password').val()
        };
        server.signup(fields, function(err, okay) {
          if (err != null) {
            return notify.error("Error during signup: " + err);
          }
          $('#signup-modal').modal('hide');
          return window.location.hash = '#/home';
        });
        return false;
      });
      return $('#signup-cancel-button').click(function() {
        $('#signup-modal').modal('hide');
        return window.location.hash = '#/';
      });
    };
  });

}).call(this);
