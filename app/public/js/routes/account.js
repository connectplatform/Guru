(function() {

  define(["load/server", "load/notify", "helpers/util"], function(server, notify, util) {
    return function(args, templ) {
      return $('#content').html(templ());
    };
  });

}).call(this);
