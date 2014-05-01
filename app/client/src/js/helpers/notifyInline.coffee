define ->
  (formSelector, fieldName, message) ->
    group = $("#{formSelector} .control-group[name=#{fieldName}]")
    help = $("#{formSelector} .control-group[name=#{fieldName}] span.help-inline")

    if message
      group.addClass 'error'
      help.html message

    else
      group.removeClass 'error'
      help.html ""
