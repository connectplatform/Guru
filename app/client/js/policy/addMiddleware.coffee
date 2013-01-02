all = [
  '/newChat'
  '/visitorChat/:id'
  '/'
  '/login'
  '/createAccount'
  '/thankYou'
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
  'routes/help', 'templates/help',
  'middleware/getRole', 'middleware/bootstrapVersioning'],
  (redirectOperators, redirectVisitors, redirectGuestsToLogin, sidebar, sbTemp, help, helpTemp, getRole, bootstrapVersioning) ->

    (dermis) ->

      renderSidebar = (args, next) ->
        sidebar args, sbTemp
        next null, args

      renderHelp = (args, next) ->
        help args, helpTemp
        next null, args

      dermis.before all, [getRole]

      # access controls
      dermis.before [
        '/newChat'
        '/visitorChat/:chatId'
        '/users'
        '/createAccount'
        '/thankYou'
        '/account'
        '/websites'
        '/specialties'
      ], [redirectOperators]

      dermis.before [
        '/thankYou'
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
        '/thankYou'
        '/dashboard'
        '/userProfile'
        '/operatorChat'
        '/users'
        '/account'
        '/websites'
        '/specialties'
      ], [redirectGuestsToLogin, renderSidebar, renderHelp]

      # Visitor routes: We're running middleware to replace bootstrap for
      # IE8 compatibility for the publicly exposed chat.
      dermis.before [
        '/newChat'
        '/visitorChat/:chatId'
        '/submitQuestion'
      ], [bootstrapVersioning]
