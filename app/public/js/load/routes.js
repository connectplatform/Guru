// Generated by CoffeeScript 1.3.3
(function() {

  define(["dermis", "policy/addMiddleware", "routes/sidebar", "templates/sidebar", 'policy/onPageLoad'], function(dermis, addMiddleware, sidebar, sbTemp, onPageLoad) {
    dermis.route('/newChat');
    dermis.route('/visitorChat/:chatId');
    dermis.route('/', 'routes/index');
    dermis.route('/login');
    dermis.route('/logout', 'routes/logout', 'routes/logout');
    dermis.route('/dashboard');
    dermis.route('/userAdmin');
    dermis.route('/operatorChat');
    dermis.route('/users');
    dermis.route('/websites');
    dermis.route('/specialties');
    dermis.route('/uploadTest');
    addMiddleware(dermis);
    dermis.init();
    return $(onPageLoad);
  });

}).call(this);
