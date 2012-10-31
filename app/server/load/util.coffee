module.exports = util =
  curry: (fn, args...) -> fn.bind fn.prototype, args...

  getType: (obj) -> Object.prototype.toString.call(obj).slice 8, -1

  compact: (arr) ->
    return (item for item in arr when not (util.getType(item) is 'Undefined'))

  # given a function, wrap it in naan and curry, then cook it
  # In English: Enables autocurrying, so if you haven't provided the callback
  # yet you'll get a curried function instead of premature execution.
  tandoor: (fn) ->
    naan = (args...) ->
      [_..., last] = args
      unless (fn.length > 0 and args.length >= fn.length) or (fn.length == 0 and util.getType(last) is 'Function')
        return util.curry naan, args...
      fn args...

    return naan

  accessKeypath: (input, keypath) ->
    keyArray = keypath.split '.'
    target = input
    for key in keyArray
      if target[key]?
        target = target[key]
      else
        return null
    return target

  queryArray: (array, queries) ->
    where = (whereConstraints, array) ->
      return array unless whereConstraints

      filteredArray = array.clone()

      for constraintKey, whereConstraint of whereConstraints
        if typeof whereConstraint is 'function'
          constraint = whereConstraint
        else if typeof whereConstraint is 'string' and whereConstraint[0] is '!'
          constraint = (item) -> item isnt whereConstraint.slice(1)
        else
          constraint = (item) -> item is whereConstraint

        filter = (item) -> constraint util.accessKeypath item, constraintKey

        filteredArray = filteredArray.filter filter

      return filteredArray

    select = (selectConstraints, array) ->
      return array unless selectConstraints

      output = []
      for item in array
        result = {}
        result[alias] = util.accessKeypath item, keypath for alias, keypath of selectConstraints
        output.push result

      return output

    results = {}
    for alias, constraints of queries
      results[alias] = select constraints.select, where constraints.where, array

    results
