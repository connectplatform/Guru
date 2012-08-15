(function() {
  var __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["dermis", "app/addMiddleware", "routes/sidebar", "templates/sidebar"], function(dermis, addMiddleware, sidebar, sbTemp) {
    var operatorPages;
    dermis.route('/newChat');
    dermis.route('/visitorChat/:id');
    dermis.route('/', 'routes/index');
    dermis.route('/login');
    dermis.route('/logout', 'routes/logout', 'routes/logout');
    dermis.route('/dashboard');
    dermis.route('/userAdmin');
    dermis.route('/operatorChat');
    dermis.route('/users');
    dermis.route('/websites');
    dermis.route('/specialties');
    addMiddleware(dermis);
    dermis.init();
    operatorPages = ['/dashboard', '/userAdmin', '/operatorChat', '/users', '/websites', '/specialties'];
    return $(function() {
      var hash;
      hash = window.rooter.hash.value();
      if (__indexOf.call(operatorPages, hash) >= 0) return sidebar({}, sbTemp);
    });
  });

}).call(this);
