(function() {

  define(function() {
    return function(formSelector, fieldName, message) {
      var group, help;
      group = $("" + formSelector + " .control-group[name=" + fieldName + "]");
      help = $("" + formSelector + " .control-group[name=" + fieldName + "] span.help-inline");
      if (message) {
        group.addClass('error');
        return help.html(message);
      } else {
        group.removeClass('error');
        return help.html("");
      }
    };
  });

}).call(this);
