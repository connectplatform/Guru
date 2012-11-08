(function() {

  define(['load/server', 'load/notify', 'helpers/util', 'helpers/renderForm'], function(server, notify, util, renderForm) {
    return function(args, templ) {
      var options;
      $('#content').html(templ());
      options = {
        name: 'account',
        title: 'Account Details',
        placement: '.form-area'
      };
      return server.ready(function() {
        return server.findModel({
          modelName: 'User'
        }, function(err, _arg) {
          var account;
          account = _arg[0];
          console.log('err:', err);
          console.log('account:', account);
          return renderForm(options, account);
        });
      });
    };
  });

}).call(this);
