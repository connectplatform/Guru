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
    server = https.createServer(options, app).listen port
    if (port is config.app.port) and config.app.ssl.redirectFrom?
      #http server to redirect to https
      redirect = (req, res) ->
        redirectTarget = "https://#{req.headers.host}#{req.url}"
        res.writeHead 301, {
          "Location": redirectTarget
        }
        res.end()
      redirectServer = http.createServer(redirect).listen config.app.ssl.redirectFrom
    return server
  else
    http.createServer(app).listen port