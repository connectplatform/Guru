define ['middleware/redirectOperators', 'middleware/redirectVisitors'], (redirectOperators, redirectVisitors) ->
  (dermis) ->

    dermis.before [
      '/newChat',
      '/visitorChat/:id',
      '/users',
      '/websites',
      '/specialties'
    ], [redirectOperators]

###
    dermis.before [
      '/',
      '/login',
      '/dashboard',
      '/userAdmin',
      '/operatorChat',
      '/users',
      '/websites',
      '/specialties',
    ], [redirectVisitors]

