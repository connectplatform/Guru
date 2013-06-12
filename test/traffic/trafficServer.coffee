connect = require 'connect'
{join} = require 'path'

port = 4005
webroot = join(__dirname, 'public')

module.exports = (cb) ->
  app = connect()
  app.use connect.static webroot
  app.listen port, ->
    console.log 'webroot:', webroot
    console.log 'listening on:', port
    cb()
