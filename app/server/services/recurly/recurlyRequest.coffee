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
  service: ({method, body, resource, rootName, modifies}, done) ->

    getErr = (details) ->
      err = if details.status in acceptableStatus then null else new Error "Could not #{verbs[method]} #{rootName or resource}."
      config.log.error err, details if err
      err

    xmlParser = config.require 'load/xmlParser'
    cache = config.require 'load/cache'

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

    cached = cache.retrieve resource
    return done getErr(cached), cached if cached and method is 'get'

    # submit the account details to recurly
    rest[method]("#{config.recurly.apiUrl}#{resource}", options).on 'complete', (data, response) =>

      details = {status: response.statusCode}.merge data
      error = getErr(details)

      unless error
        cache.store modifies, details if modifies
        cache.store resource, details if method is 'get'

      done error, details
