(function() {

  define(['middleware/redirectOperators', 'middleware/redirectVisitors'], function(redirectOperators, redirectVisitors) {
    return function(dermis) {
      dermis.before(['/newChat', '/visitorChat/:id', '/users', '/websites', '/specialties'], [redirectOperators]);
      return dermis.before(['/', '/login', '/dashboard', '/userAdmin', '/operatorChat', '/users', '/websites', '/specialties'], [redirectVisitors]);
    };
  });

}).call(this);
