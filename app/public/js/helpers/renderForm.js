(function() {

  define(['load/server', "templates/renderForm", 'helpers/validateField', 'helpers/notifyInline', 'helpers/util'], function(server, renderForm, validateField, notifyInline, _arg) {
    var random;
    random = _arg.random;
    return function(options, fields, receive) {
      var f, validatedFields, _i, _len;
      if (options == null) options = {};
      if (!(fields && fields.length > 0)) {
        server.serverLog({
          message: "Called renderForm with no fields.",
          context: {
            fields: fields,
            options: options
          }
        });
        $(options.placement).html("Oops! There's no data for this form. The support team has been notified.");
        return;
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
      $("#" + options.name).find(':input').filter(':visible:first').focus();
      validatedFields = fields.filter(function(f) {
        return f.required || f.validation;
      });
      validatedFields.map(function(field) {
        var name;
        name = field.name;
        return $("" + options.placement + " .controls [name=" + name + "]").change(function() {
          var error;
          error = validateField(field, $(this).val());
          return notifyInline(options.placement, field.name, error);
        });
      });
      return $("#" + options.name).submit(function(evt) {
        var error, field, formParams, toObj, valid, _j, _len2;
        evt.preventDefault();
        toObj = function(obj, item) {
          obj[item.name] = item.value;
          return obj;
        };
        formParams = $(this).serializeArray().reduce(toObj, {});
        valid = true;
        for (_j = 0, _len2 = validatedFields.length; _j < _len2; _j++) {
          field = validatedFields[_j];
          error = validateField(field, formParams[field.name]);
          notifyInline(options.placement, field.name, error);
          if (error) valid = false;
        }
        if (!valid) return;
        return receive(formParams);
      });
    };
  });

}).call(this);
