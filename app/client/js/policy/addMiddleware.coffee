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
  'middleware/redirectGuestsToLogin', 'routes/help', 'templates/help',
  'middleware/getRole', 'components/navBar', 'components/operatorChat',
  'load/particle', 'app/config'],
  (deps...) ->
    [redirectOperators, redirectVisitors, redirectGuestsToLogin, help,
      helpTemp, getRole, navBar, operatorChat, particle, {appName}] = deps

    (dermis) ->

      renderNavbar = (args, next) ->
        role = {args}
        sessionSecret = $.cookies.get 'session'
        particle.init {sessionSecret}, (err, models) ->
          return next err if err

          navBar.attachTo "#navBar", {role, models, appName}
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
      ], [redirectGuestsToLogin, renderNavbar, renderHelp]
