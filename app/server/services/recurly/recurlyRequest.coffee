rest = require 'restler'
easyxml = require 'easyxml'

verbs =
  get: 'find'
  put: 'update'
  post: 'create'

acceptableStatus = [200, 201]

module.exports =
  optional: ['body', 'rootName']
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
    else
      options.data = ''

    # submit the account details to recurly
    rest[method]("#{config.recurly.apiUrl}#{resource}", options).on 'complete', (data, response) =>
      #{inspect} = require 'util'
      #console.log 'response:', inspect response, null, 1
      #console.log 'data:', data

      err = if response.statusCode in acceptableStatus then null else "Could not #{verbs[method]} #{rootName or resource}."
      details = {status: response.statusCode}.merge data

      config.log.error err, details if err
      done err, details
