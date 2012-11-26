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
      #config.log 'submitting data:', options.data
    else
      options.data = ''

    {inspect} = require 'util'
    #config.log "about to submit request: #{method.toUpperCase()} #{resource}, data:\n#{inspect options}" if method is 'post' and resource.match /subscription/

    # submit the account details to recurly
    rest[method]("#{config.recurly.apiUrl}#{resource}", options).on 'complete', (data, response) =>
      #config.log "Recurly: #{method.toUpperCase()} #{resource}: #{response.statusCode}"
      #config.log 'recurly response:', inspect response, null, 1
      #config.log 'recurly data:', inspect data, null, 4 if method is 'post' and resource.match /subscription/

      err = if response.statusCode in acceptableStatus then null else "Could not #{verbs[method]} #{rootName or resource}."
      details = {status: response.statusCode}.merge data

      config.log.error err, details if err
      done err, details
