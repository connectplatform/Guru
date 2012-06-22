define ["dermis"], (dermis) ->

  # routes for visitors to join chat
  dermis.route '/newChat'
  dermis.route '/visitorChat/:id'

  # login for backend users
  dermis.route '/', 'routes/index'
  dermis.route '/login'
  dermis.route '/logout'
  #dermis.route '/signup' # don't allow until phase 3?

  # workflow for backend users
  dermis.route '/dashboard'
  dermis.route '/userAdmin'
  dermis.route '/operatorChat'

  dermis.init()
