module.exports = (stack, processSideEffects) ->
  stack.map (fn) ->

    # return signature required by waterfall
    (params, next) ->

      # run the filtered function
      triggerEffects = (err, out, effects) ->
        return next err, out if err or not effects

        # perform any side effects
        processSideEffects effects, (err) ->
          next err, out

      fn params, triggerEffects, processSideEffects
