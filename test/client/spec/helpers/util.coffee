define ->

  defaultTimeout: 400

  # these are used with waitsFor
  hasText: (selector, value) ->
    -> ($(selector).text() is value)

  exists: (selector) ->
    -> $(selector).length > 0

  notExists: (selector) ->
    -> $(selector).length is 0

  # sugar to allow convenient time delays
  delay: (time, fn) ->
    if typeof time is 'function' and not fn
      time = @defaultTimeout
      fn = time
    setTimeout fn, time
