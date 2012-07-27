define ["dermis", "routes/sidebar", "templates/sidebar"], (dermis, sidebar, sbTemp) ->

  # routes for visitors to join chat
  dermis.route '/newChat'
  dermis.route '/visitorChat/:id'

  # login for backend users
  dermis.route '/', 'routes/index'
  dermis.route '/login'
  dermis.route '/logout', 'routes/logout', 'routes/logout'
  #dermis.route '/signup' # don't allow until phase 3?

  # main screens for backend users
  dermis.route '/dashboard'
  dermis.route '/userAdmin'
  dermis.route '/operatorChat'

  # CRUD screens for admin
  dermis.route '/users'
  dermis.route '/websites'
  dermis.route '/departments'

  # chat actions
  dermis.route '/joinChat/:id'

  dermis.init()

  $ ->
    hash = window.rooter.hash.value()
    console.log 'hash:', hash
    if hash in [
      '/dashboard',
      '/userAdmin',
      '/operatorChat',
      '/users',
      '/websites',
      '/departments'
    ]
      console.log 'rendering sidebar'
      sidebar {}, sbTemp
