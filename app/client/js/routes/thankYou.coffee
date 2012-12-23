define [], ->
  (args, templ) ->
    $('#content').html templ()
    $('#help a').click()
