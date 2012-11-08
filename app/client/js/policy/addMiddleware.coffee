all = [
  '/newChat'
  '/visitorChat/:id'
  '/'
  '/login'
  '/createAccount'
  '/logout'
  '/dashboard'
  '/userProfile'
  '/operatorChat'
  '/users'
  '/account'
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
        sidebar args, sbTemp
        next null, args

      dermis.before all, [getRole]

      # access controls
      dermis.before [
        '/newChat'
        '/visitorChat/:chatId'
        '/users'
        '/account'
        '/websites'
        '/specialties'
      ], [redirectOperators]

      dermis.before [
        '/'
        '/login'
        '/createAccount'
        '/dashboard'
        '/userProfile'
        '/operatorChat'
        '/users'
        '/account'
        '/websites'
        '/specialties'
      ], [redirectVisitors]

      dermis.before [
        '/dashboard'
        '/userProfile'
        '/operatorChat'
        '/users'
        '/account'
        '/websites'
        '/specialties'
      ], [redirectGuestsToLogin, renderSidebar]
