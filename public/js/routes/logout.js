// Generated by CoffeeScript 1.3.1
(function() {

  define(["destiny/server", "destiny/notify"], function(server, notify, templ) {
    return function() {
      server.cookie('login', null);
      return window.location = '/';
    };
  });

}).call(this);
