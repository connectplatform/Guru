(function() {

  define(["templates/renderForm", 'helpers/util'], function(renderForm, _arg) {
    var random;
    random = _arg.random;
    return function(options, fields, next) {
      var f, _i, _len;
      if (options == null) options = {};
      if (!(fields && fields.length > 0)) {
        return next("Called renderForm with no fields.");
      }
      for (_i = 0, _len = fields.length; _i < _len; _i++) {
        f = fields[_i];
        f["default"] || (f["default"] = '');
      }
      options.name || (options.name = random());
      options.submitText || (options.submitText = 'Send');
      options.placement || (options.placement = '#content');
      $(options.placement).html(renderForm({
        options: options,
        fields: fields
      }));
      $("#" + options.name + "-form").find(':input').filter(':visible:first');
      return $("#" + options.name + "-form").submit(function(evt) {
        var formParams, toObj;
        evt.preventDefault();
        toObj = function(obj, item) {
          obj[item.name] = item.value;
          return obj;
        };
        formParams = $(this).serializeArray().reduce(toObj, {});
        return next(null, {
          action: 'receive',
          params: formParams
        });
      });
    };
  });

}).call(this);
