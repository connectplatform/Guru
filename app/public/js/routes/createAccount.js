(function() {

  define(["load/server", "load/notify", "helpers/util", 'helpers/renderForm'], function(server, notify, util, renderForm) {
    return function(args, templ) {
      var fields, options;
      $("#content").html(templ());
      fields = [
        {
          name: 'email',
          inputType: 'text',
          "default": 'name@example.com',
          label: 'Email',
          validation: function(email) {
            return /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(email);
          },
          required: true
        }, {
          name: 'firstName',
          inputType: 'text',
          "default": 'Bob',
          label: 'First Name',
          required: true
        }, {
          name: 'lastName',
          inputType: 'text',
          "default": 'Smith',
          label: 'Last Name',
          required: true
        }, {
          name: 'password',
          inputType: 'password',
          "default": '',
          label: 'Password',
          required: true
        }, {
          name: 'confirmPassword',
          inputType: 'password',
          "default": '',
          label: 'Confirm Password',
          validation: function(text) {
            if (text !== $(".controls [name=password]").val()) {
              return 'Password confirmation must match.';
            }
          }
        }
      ];
      options = {
        name: 'createAccount',
        submitText: 'Create Account',
        placement: '#content .form-area'
      };
      return server.ready(function() {
        return renderForm(options, fields, function(params) {
          return server.createAccount(params, function(err, args) {
            console.log('err:', err);
            console.log('args:', args);
            if (err) {
              return notify.error(err);
            } else {
              return window.location.hash = '/account';
            }
          });
        });
      });
    };
  });

}).call(this);
