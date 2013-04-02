define ["dermis", "policy/addMiddleware", "routes/sidebar", "templates/sidebar", 'policy/onPageLoad'],
 (dermis, addMiddleware, sidebar, sbTemp, onPageLoad) ->

    # routes for visitors to join chat
    dermis.route '/newChat'
    dermis.route '/visitorChat/:chatId'
    dermis.route '/submitQuestion'

    # account creation for new owners
    dermis.route '/createAccount'
    dermis.route '/thankYou'

    # login for backend users
    dermis.route '/', 'routes/index'
    dermis.route '/login'
    dermis.route '/logout', 'routes/logout', 'routes/logout'
    dermis.route '/resetPassword'
    dermis.route '/forgotPassword'

    # main screens for backend users
    dermis.route '/dashboard'
    dermis.route '/userProfile'
    dermis.route '/operatorChat'

    # utility route for printing
    dermis.route '/printChat/:chatId', 'routes/printChat', 'routes/printChat'

    # CRUD screens for admin
    dermis.route '/account'
    dermis.route '/users'
    dermis.route '/websites'
    dermis.route '/specialties'

    # Test route
    dermis.route '/uploadTest' # TODO: remove when file uploads are working
    dermis.route '/testPulsar'

    # chat actions

    addMiddleware dermis

    dermis.init()

    $ onPageLoad
