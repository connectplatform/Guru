(function() {

  define(["load/server", "load/notify", "helpers/util", 'helpers/renderForm'], function(server, notify, util, renderForm) {
    return function(args, templ) {
      var fields, options;
      console.log('loaded createAccount route');
      $("#content").html(templ());
      fields = [
        {
          name: 'email',
          inputType: 'text',
          "default": 'name@example.com',
          label: 'Email'
        }, {
          name: 'firstName',
          inputType: 'text',
          "default": 'Bob',
          label: 'First Name'
        }, {
          name: 'lastName',
          inputType: 'text',
          "default": 'Smith',
          label: 'Last Name'
        }, {
          name: 'password',
          inputType: 'password',
          "default": '',
          label: 'Password'
        }, {
          name: 'password',
          inputType: 'password',
          "default": '',
          label: 'Confirm Password'
        }
      ];
      options = {
        name: 'createAccount',
        submitText: 'Create Account',
        placement: '#content .form-area'
      };
      return server.ready(function() {
        return renderForm(options, fields, function(err, params) {
          if (err) console.log('err:', err);
          console.log('params:', params.params);
          return server.createAccount({
            fields: params.params
          }, function(err, args) {
            console.log('err:', err);
            return console.log('args:', args);
          });
        });
      });
    };
  });

}).call(this);
