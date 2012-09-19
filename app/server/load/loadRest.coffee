{readdirSync} = require 'fs'
{join, basename, extname} = require 'path'

module.exports = (restDir) ->
  resourceMap = {}
  files = readdirSync restDir

  for file in files
    ext = extname file
    if ext is '.coffee'
      resourceName = basename file, ext
      resource = require join restDir, file
      resourceMap[resourceName] = resource

  #return a function that will use the resource map on incoming requests
  return (req, res) ->
    [empty, websiteName, requestName, args...] = req.url.split '/'

    handler = resourceMap[requestName] or ->
    handler
      website: websiteName
      args: args
      response: res
