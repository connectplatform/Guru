rest = require 'restler'
easyxml = require 'easyxml'

verbs =
  get: 'find'
  put: 'update'
  post: 'create'

status =
  get: 200
  put: 201
  post: 201

module.exports =
  optional: ['body']
  required: ['method', 'resource']
  service: ({method, body, resource, rootName}, done) ->

    xmlParser = config.require 'load/xmlParser'

    method ||= 'get'
    options =
      parser: xmlParser().parseString
      username: config.recurly.apiKey
      password: ''
      headers:
        'Accept': 'application/xml'
        'Content-Type': 'application/xml'

    if body
      options.data = '<?xml version="1.0" encoding="UTF-8"?>\n'
      options.data += easyxml.render body, rootName
      #console.log 'submitting data:', options.data

    # submit the account details to recurly
    rest[method]("#{config.recurly.apiUrl}#{resource}", options).on 'complete', (data, response) =>
      #console.log 'response:', inspect response, null, 1

      err = if response.statusCode is status[method] then null else "Could not #{verbs[method]} #{rootName or resource}."
      done err, {status: response.statusCode, raw: response.rawEncoded}.merge data
