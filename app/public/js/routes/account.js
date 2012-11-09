(function() {

  define(['load/server', 'load/notify', 'helpers/util', 'helpers/renderForm'], function(server, notify, _arg, renderForm) {
    var toTitle;
    toTitle = _arg.toTitle;
    return function(args, templ) {
      var options;
      $('#content').html(templ());
      options = {
        title: 'Account Details',
        placement: '.form-area',
        submit: 'disabled'
      };
      return server.ready(function() {
        return server.findModel({
          modelName: 'Account'
        }, function(err, accounts) {
          var account, fieldName, fieldVal, fields;
          if (err) {
            $(options.placement).html('Could not find account.');
            return;
          }
          account = accounts[0];
          fields = (function() {
            var _results;
            _results = [];
            for (fieldName in account) {
              fieldVal = account[fieldName];
              if (fieldName !== '_id') {
                _results.push({
                  label: toTitle(fieldName),
                  name: fieldName,
                  value: fieldVal,
                  inputType: 'static'
                });
              }
            }
            return _results;
          })();
          return renderForm(options, fields);
        });
      });
    };
  });

}).call(this);