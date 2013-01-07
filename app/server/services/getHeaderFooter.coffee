async = require 'async'
{readFile, exists} = require 'fs'
cache = config.require 'load/cache'

refreshFiles = (done) ->
  if config.paths.static and not cache.retrieve 'static.header'

    loadPartial = (partialName, next) ->
      filename = config.path "static/#{partialName}.html"

      exists filename, (exists) ->
        if exists
          readFile filename, 'utf8', (err, html) ->
            cache.store "static.#{partialName}", html
            next()

        else
          next()

    async.forEach ['header', 'footer'], loadPartial, done

  else
    done()

refreshFiles -> # empty callback, just fire and forget on server startup

module.exports =
  service: (args, done) ->
    refreshFiles ->

      header = cache.retrieve('static.header') or ''
      footer = cache.retrieve('static.footer') or ''

      done null, {header: header, footer: footer}
