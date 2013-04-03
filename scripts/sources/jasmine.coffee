connect = require 'connect'
{join} = require 'path'

port = 4003

module.exports = (args) ->
  app = connect()
  webroot = join(__dirname, '../../test/client/public/')
  app.use connect.static webroot
  app.listen port
  config.log 'webroot:', webroot
  config.log 'listening on:', port
