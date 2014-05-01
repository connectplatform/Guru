module.exports = (req, res) ->
  result = {
    port: global.config.app.port
    pulsarPort: global.config.app.pulsarPort
    url: global.config.app.url
    baseUrl: global.config.app.baseUrl
    api: global.config.app.api
  }

  res.end JSON.stringify result
