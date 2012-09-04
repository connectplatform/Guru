getType = (obj) -> Object.prototype.toString.call obj

compact = (arr) ->
  return (item for item in arr when not (getType(item) is '[object Undefined]'))

curry = (fn, args...) ->
  args = compact args
  fn.bind fn.prototype, args...

module.exports =
  curry: curry
  getType: getType
  compact: compact

  # given a function, wrap it in naan and curry, then cook it
  # In English: Enables autocurrying, so if you haven't provided the callback
  # yet you'll get a curried function instead of premature execution.
  tandoor: (meat) ->
    naan = (args..., next) ->
      unless getType(next) == '[object Function]'
        return curry naan, args..., next
      meat args..., next

    return naan
