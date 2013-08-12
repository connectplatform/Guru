define ['vendor/jquery'], ($) ->
  append = (node, template, data) ->
    $(node).append (template data)

  prepend = (node, template, data) ->
    $(node).prepend (template data)

  replace = (node, template, data) ->
    $(node).html (template data)

  makeRender = (node, template) ->
    append: (data) -> append node, template, data
    prepend: (data) -> prepend node, template, data
    replace: (data) -> replace node, template, data

  return {append, prepend, replace, makeRender}
