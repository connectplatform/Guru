(function() {

  define(['helpers/util'], function(_arg) {
    var getType;
    getType = _arg.getType;
    return function(field, value) {
      var label, required, result, validation;
      required = field.required, validation = field.validation, label = field.label;
      if (required && !value) return "" + label + " is required.";
      if (!required && !value) return;
      if (validation) {
        result = validation(value);
        if (result === false) {
          return "Please enter a valid " + label + ".";
        } else if (getType(result) === 'String') {
          return result;
        } else {

        }
      }
    };
  });

}).call(this);
