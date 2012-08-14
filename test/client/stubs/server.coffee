cookies = {}

define [], ->
  ready: (fn) -> fn()
  cookie: (key, val) ->
    if val?
      cookies[key] = val
    else
      return cookies[key]
