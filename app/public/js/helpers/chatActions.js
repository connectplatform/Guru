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
            console.log('email: ', email);
            $("#enterEmail").modal("hide");
            return server.ready(function() {
              return server.emailChat(chatId, email, function(err, response) {
                if (err) {
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