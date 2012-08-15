(function() {

  define(["dermis", "app/addMiddleware", "routes/sidebar", "templates/sidebar"], function(dermis, addMiddleware, sidebar, sbTemp) {
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
    return dermis.init();
  });

}).call(this);
