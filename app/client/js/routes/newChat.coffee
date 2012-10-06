define ["load/server", "load/notify", 'helpers/util', 'routes/newChat.fsm'], (server, notify, util, fsm) ->
  {getDomain} = util

  (_, templ, queryParams={}) ->

    # -> render the user data form
    renderForm = (fields, next) ->
      $("#content").html templ fields: fields
      $("#newChat-form").find(':input').filter(':visible:first')

      $("#newChat-form").submit (evt) ->
        evt.preventDefault()

        toObj = (obj, item) ->
          obj[item.name] = item.value
          return obj
        formParams = $(@).serializeArray().reduce toObj, {}
        next null, params: formParams

    # input cleanup
    $("#content").html "Loading..."
    delete queryParams["undefined"]
    unless queryParams.websiteUrl
      queryParams.websiteUrl = getDomain document.referrer

    # fire off chat creation process
    server.ready ->
      fsm(renderForm: renderForm, params: queryParams).states.initial()
