{readdirSync, statSync} = require 'fs'
{join, basename, extname} = require 'path'

module.exports = getServices = (folder, prefix=null) ->

  services = {}

  # find service definitions
  for file in readdirSync folder
    ext = extname file
    fullname = [prefix, basename(file, ext)].compact().join '/'
    filePath = join folder, file

    if require.extensions[ext]?

      # get the service, wrap it in middleware, and connect it to vein
      services[fullname] = require filePath

    else if statSync(filePath).isDirectory()
      services.merge getServices(filePath, fullname)

  return services
