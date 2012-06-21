define ["dermis"], (dermis) ->

  # routes for visitors to join chat
  dermis.route '/newChat'
  dermis.route '/visitorChat/:id'

  # login for backend users
  dermis.route '/'
  dermis.route '/login'
  dermis.route '/logout'
  dermis.route '/signup'

  # workflow for backend users
  dermis.route '/dashboard'
  dermis.route '/operatorChat'

  dermis.init()
