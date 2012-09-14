define ["dermis", "policy/addMiddleware", "routes/sidebar", "templates/sidebar", 'policy/onPageLoad'],
 (dermis, addMiddleware, sidebar, sbTemp, onPageLoad) ->

    # routes for visitors to join chat
    dermis.route '/newChat'
    dermis.route '/visitorChat/:chatId'

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
    dermis.route '/specialties'

    # Test route
    dermis.route '/s3test' # TODO: remove when file uploads are working

    # chat actions

    addMiddleware dermis

    dermis.init()

    $ onPageLoad
