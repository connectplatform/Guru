# dermis use 'require' in order to load 'route' and 'template'.
# in order to r.js include required routes and templates into result file
# we need to specify dependencies explicitly
define [
    "vendor/dermis", "policy/addMiddleware", "routes/sidebar", "templates/sidebar", "policy/onPageLoad",

    # /newChat route
    "routes/newChat", "templates/newChat",

    # /visitorChat route
    "routes/visitorChat", "templates/visitorChat",

    # /submitQuestion route
    "routes/submitQuestion", "templates/submitQuestion",

    # /submitQuestion route
    "routes/submitQuestion", "templates/submitQuestion",

    # /createAccount route
    "routes/createAccount", "templates/createAccount",

    # /thankYou route
    "routes/thankYou", "templates/thankYou",

    # / route
    "routes/index", "templates/index",

    # /login route
    "routes/login", "templates/login",

    # /logout route
    "routes/logout", # TODO: it have template?

    # /resetPassword route
    "routes/resetPassword", "templates/resetPassword",

    # /forgotPassword route
    "routes/forgotPassword", "templates/forgotPassword",

    # /dashboard route
    "routes/dashboard", "templates/dashboard",

    # /userProfile route
    "routes/userProfile", "templates/userProfile",

    # /operatorChat route
    "routes/operatorChat", "templates/operatorChat",

    # /printChat route
    "routes/printChat", # TODO: it have template?

    # /account route
    "routes/account", "templates/account",

    # /users route
    "routes/users", "templates/users",

    # /websites route
    "routes/websites", "templates/websites",

    # /specialties route
    "routes/specialties", "templates/specialties",

    # /uploadTest route
    "routes/uploadTest", "templates/uploadTest", # TODO: see comment for /uploadTest route below

    # /testPulsar route - there are no these files
    #"routes/testPulsar", "templates/testPulsar"
  ],
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
