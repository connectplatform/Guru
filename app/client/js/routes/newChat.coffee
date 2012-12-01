define ["load/server", "load/notify", 'helpers/util', 'routes/newChat.fsm'],
  (server, notify, util, fsm) ->
    {getDomain} = util

    (_, templ, queryParams={}) ->

      # input cleanup
      $("#content").html templ()
      delete queryParams["undefined"]
      unless queryParams.websiteUrl
        queryParams.websiteUrl = getDomain document.referrer

      # fire off chat creation process
      server.ready ->
        fsm(queryParams)
