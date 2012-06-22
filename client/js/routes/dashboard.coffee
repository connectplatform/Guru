define ["guru/server", "guru/notify", "routes/sidebar", "templates/sidebar"], (server, notify, sidebar, sideTemp) ->
  (args, templ) ->

    sidebar {}, sideTemp
    $('#content').html templ()
