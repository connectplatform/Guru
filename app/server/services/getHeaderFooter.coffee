{readFileSync, existsSync} = require 'fs'
cache = config.require 'load/cache'

refreshFiles = ->
  if config.paths.static
    for part in ['header', 'footer']
      filename = config.path "static/#{part}.html"
      if existsSync filename
        html = readFileSync filename, 'utf8'
        cache.store "static.#{part}", html

refreshFiles()

module.exports =
  service: (args, done) ->
    unless cache.retrieve 'static.header'
      refreshFiles()

    header = cache.retrieve('static.header') or ''
    footer = cache.retrieve('static.footer') or ''

    done null, {header: header, footer: footer}
