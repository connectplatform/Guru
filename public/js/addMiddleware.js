(function() {
  var all;

  all = ['/newChat', '/visitorChat/:id', '/', '/login', '/logout', '/dashboard', '/userAdmin', '/operatorChat', '/users', '/websites', '/specialties'];

  define(['middleware/redirectOperators', 'middleware/redirectVisitors', 'middleware/redirectGuestsToLogin', 'routes/sidebar', 'templates/sidebar', 'middleware/getRole'], function(redirectOperators, redirectVisitors, redirectGuestsToLogin, sidebar, sbTemp, getRole) {
    return function(dermis) {
      var renderSidebar;
      renderSidebar = function(args, next) {
        sidebar(args, sbTemp);
        return next(null, args);
      };
      dermis.before(all, [getRole]);
      dermis.before(['/newChat', '/visitorChat/:chatId', '/users', '/websites', '/specialties'], [redirectOperators]);
      dermis.before(['/', '/login', '/dashboard', '/userAdmin', '/operatorChat', '/users', '/websites', '/specialties'], [redirectVisitors]);
      return dermis.before(['/dashboard', '/userAdmin', '/operatorChat', '/users', '/websites', '/specialties'], [redirectGuestsToLogin, renderSidebar]);
    };
  });

}).call(this);
