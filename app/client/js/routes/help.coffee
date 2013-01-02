define ->
  (args, templ) ->
    console.log args
    $('#help').html templ role: args.role
