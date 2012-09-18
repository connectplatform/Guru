(function() {

  define(["dermis", "policy/addMiddleware", "routes/sidebar", "templates/sidebar", 'policy/onPageLoad'], function(dermis, addMiddleware, sidebar, sbTemp, onPageLoad) {
    dermis.route('/newChat');
    dermis.route('/visitorChat/:chatId');
    dermis.route('/', 'routes/index');
    dermis.route('/login');
    dermis.route('/logout', 'routes/logout', 'routes/logout');
    dermis.route('/resetPassword');
    dermis.route('/forgotPassword');
    dermis.route('/dashboard');
    dermis.route('/userProfile');
    dermis.route('/operatorChat');
    dermis.route('/users');
    dermis.route('/websites');
    dermis.route('/specialties');
    addMiddleware(dermis);
    dermis.init();
    return $(onPageLoad);
  });

}).call(this);