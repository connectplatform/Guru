(function() {

  define(['templates/enterEmail', 'load/server', 'load/notify'], function(enterEmail, server, notify) {
    return {
      print: function(chatId) {
        return function(evt) {
          var location;
          evt.preventDefault();
          location = "https://" + window.location.host + "/#/printChat/" + chatId;
          return window.open(location);
        };
      },
      email: function(chatId) {
        return function(evt) {
          evt.preventDefault();
          $("#selectModal").html(enterEmail());
          $("#enterEmail").modal();
          return $(".enterEmailForm").submit(function(evt) {
            var email;
            evt.preventDefault();
            email = $('#enterEmail .email').val();
            $("#enterEmail").modal("hide");
            return server.ready(function() {
              return server.emailChat({
                chatId: chatId,
                email: email
              }, function(err, response) {
                if (err) {
                  server.log('Error sending email', {
                    error: err,
                    severity: 'warn',
                    email: email
                  });
                  return notify.error('Error sending email: ', err);
                } else {
                  return notify.success('Email sent');
                }
              });
            });
          });
        };
      }
    };
  });

}).call(this);
