{readdirSync} = require 'fs'
{join, basename, extname} = require 'path'
url = require 'url'

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

    # find service to call, or return 404
    pathParts = req._parsedUrl.pathname.split('/').remove ''
    resourceName = pathParts[0]
    service = resourceMap[resourceName] or ->
      res.writeHead 404
      res.end()

    # call service
    service {
        #origReq: req
        url: req.url
        headers: req.headers
        query: req.query || {}
        pathParts: pathParts
        cookies: req.cookies
      }, res
