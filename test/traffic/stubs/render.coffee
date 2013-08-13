define ['vendor/jquery'], ($) ->
  append = (sel, template, data) ->
    sel.append (template data)

  prepend = (sel, template, data) ->
    sel.prepend (template data)

  replace = (sel, template, data) ->
    sel.html (template data)

  makeRender = (sel, template) ->
    append: (data) -> append sel, template, data
    prepend: (data) -> prepend sel, template, data
    replace: (data) -> replace sel, template, data

  return {append, prepend, replace, makeRender}
