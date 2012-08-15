all = [
  '/newChat'
  '/visitorChat/:id'
  '/'
  '/login'
  '/logout'
  '/dashboard'
  '/userAdmin'
  '/operatorChat'
  '/users'
  '/websites'
  '/specialties'
]

define ['middleware/redirectOperators', 'middleware/redirectVisitors',
  'middleware/redirectGuestsToLogin',
  'routes/sidebar', 'templates/sidebar',
  'middleware/getRole'],
  (redirectOperators, redirectVisitors, redirectGuestsToLogin, sidebar, sbTemp, getRole) ->
    (dermis) ->

      renderSidebar = (args, next) ->
        sidebar {}, sbTemp
        next()

      dermis.before all, [getRole]

      # access controls
      dermis.before [
        '/newChat'
        '/visitorChat/:id'
        '/users'
        '/websites'
        '/specialties'
      ], [redirectOperators]

      dermis.before [
        '/'
        '/login'
        '/dashboard'
        '/userAdmin'
        '/operatorChat'
        '/users'
        '/websites'
        '/specialties'
      ], [redirectVisitors]

      dermis.before [
        '/dashboard'
        '/userAdmin'
        '/operatorChat'
        '/users'
        '/websites'
        '/specialties'
      ], [redirectGuestsToLogin, renderSidebar]
