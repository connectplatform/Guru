define ->

  defaultTimeout: 400

  # verify that some element in the DOM contains text
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
