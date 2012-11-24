xml2js = require 'xml2js'

module.exports = (options={}) ->
  defaults =
    explicitArray: false
    mergeAttrs: true
    charkey: 'value'

  parser = new xml2js.Parser {}.merge(defaults).merge options
