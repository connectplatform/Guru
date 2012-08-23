config = require './config'

{join} = require 'path'
fs = require 'fs'

http = require 'http'
https = require 'https'

read = (file) -> fs.readFileSync join(__dirname, file), 'utf8'

module.exports = (port, app) ->
  app ?= ->

  if config.app.ssl

    # read cert files
    options =
      key: read config.app.ssl.key
      cert: read config.app.ssl.cert
      ca: config.app.ssl.ca.map read

    # create server with ssl
    https.createServer(options, app).listen port
  else
    http.createServer(app).listen port
