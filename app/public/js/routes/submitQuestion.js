(function() {

  define(["load/server", "load/notify", 'helpers/renderForm'], function(server, notify, renderForm) {
    return function(_, templ, queryParams) {
      var fields, options;
      if (queryParams == null) queryParams = {};
      $('#content').html(templ());
      options = {
        name: 'email',
        placement: '.form-area'
      };
      fields = [
        {
          name: 'email',
          inputType: 'text',
          "default": 'name@example.com',
          label: 'Email'
        }, {
          name: 'subject',
          inputType: 'text',
          label: 'Subject'
        }, {
          name: 'body',
          inputType: 'paragraph',
          label: 'Message'
        }
      ];
      return renderForm(options, fields, function(err, formData) {
        var args;
        if (err) return notify.error("Error: " + err);
        args = queryParams.merge({
          emailData: formData.params
        });
        return server.ready(function() {
          return server.submitQuestion(args, function(err, result) {
            if (err) return notify.error("Error: " + err);
            return window.location.hash = '/submitSuccess';
          });
        });
      });
    };
  });

}).call(this);
