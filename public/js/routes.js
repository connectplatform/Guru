// Generated by CoffeeScript 1.3.1
(function() {

  define(["dermis", "routes/sidebar", "templates/sidebar"], function(dermis, sidebar, sbTemp) {
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
    dermis.route('/departments');
    dermis.route('/joinChat/:id');
    dermis.init();
    return $(function() {
      var hash;
      hash = window.rooter.hash.value();
      console.log('hash:', hash);
      if (hash === '/dashboard' || hash === '/userAdmin' || hash === '/operatorChat' || hash === '/users' || hash === '/websites' || hash === '/departments') {
        console.log('rendering sidebar');
        return sidebar({}, sbTemp);
      }
    });
  });

}).call(this);
