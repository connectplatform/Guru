define ->

  # verify that some element in the DOM contains text
  hasText: (selector, value) ->
    -> ($(selector).text() is value)

  exists: (selector, value) ->
    -> $(selector).length > 0

  # sugar to allow convenient time delays
  delay: (time, fn) -> setTimeout fn, time

