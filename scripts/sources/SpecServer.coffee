connect = require 'connect'
{join} = require 'path'

port = 4003

module.exports = (args) ->
  app = connect()
  webroot = join(__dirname, '../../test/client/public/')
  app.use connect.static webroot
  app.listen port
  console.log 'webroot:', webroot
  console.log 'listening on:', port
