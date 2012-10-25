{readdirSync} = require 'fs'
{join, basename, extname} = require 'path'

module.exports = (folder) ->

  services = {}

  # find service definitions
  for file in readdirSync folder
    ext = extname file
    serviceName = basename file, ext
    if require.extensions[ext]?

      # get the service, wrap it in middleware, and connect it to vein
      services[serviceName] = require join folder, file

  return services
