sugar = require 'sugar'
memwatch = require 'memwatch'
logger = require './logger'

presetFormats =
  raw: (stats) -> stats
  default: (stats) -> stats.change.size
  details: (stats) ->
    top3 = stats.change.details.sortBy('size_bytes', true).slice(0, 3)
    summary = {}
    for stat in top3
      summary[stat.what] = stat.size
    {diff: stats.change.size, biggest: summary}

format = presetFormats.default

module.exports = tools =
  format: (stats) -> format stats
  memwatch: memwatch

  changeFormat: (fn) ->
    if (typeof fn) is 'function'
      format = fn
    else
      format = (presetFormats[fn] or presetFormats.default)

  memdiff: (name, fn, args..., cb) ->
    diff = new memwatch.HeapDiff()

    fn args..., (results...) ->
      stats = diff.end()
      logger "'#{name}' diff:", format(stats)

      cb results...

  noop: (name, fn, args..., cb) ->
    fn args..., cb

  filter: (target) ->
    (name, args...) ->
      if name is target
        tools.memdiff name, args...
      else
        tools.noop name, args...

  postMortem: ->

    keypress = require 'keypress'
    keypress(process.stdin)
    process.stdin.resume()
    process.stdin.setRawMode true

    diff = new memwatch.HeapDiff()

    process.stdin.on 'keypress', (ch, key) ->
      if key?.ctrl && key.name is 'c'

        stats = diff.end()
        logger "manual trigger:", format(stats)

        process.exit()

      if key?.ctrl && key.name is 'd'
        process.exit()
