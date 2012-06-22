define ["destiny/server", "destiny/notify"], (server, notify, templ) ->
  ->
    server.cookie 'login', null # delete login cookie
    window.location = '/'
