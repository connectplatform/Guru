define ['vendor/jquery'], ($) ->
  append = (sel, template, data) ->
    sel.append (template data)

  prepend = (sel, template, data) ->
    sel.prepend (template data)

  replace = (sel, template, data) ->
    sel.html (template data)

  makeRender = (node, template) ->
    append: (data) -> append node, template, data
    prepend: (data) -> prepend node, template, data
    replace: (data) -> replace node, template, data

  return {append, prepend, replace, makeRender}
