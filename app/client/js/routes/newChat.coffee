define ["load/server", "load/notify", 'helpers/util', 'routes/newChat.fsm'],
  (server, notify, util, fsm) ->
    {getDomain} = util

    (_, templ, queryParams={}) ->
      console.log 'server unready'

      # input cleanup
      $("#content").html templ()
      delete queryParams["undefined"]
      unless queryParams.websiteUrl
        queryParams.websiteUrl = getDomain document.referrer

      console.log 'server unready 2'

      # fire off chat creation process
      server.ready ->
        console.log 'server READY!'
        fsm(params: queryParams)
