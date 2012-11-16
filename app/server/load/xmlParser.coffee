xml2js = require 'xml2js'

module.exports = (options={}) ->
  defaults =
    explicitArray: false
    mergeAttrs: true

  parser = new xml2js.Parser(defaults.merge options)
