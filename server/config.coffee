environment = process.env.NODE_ENV or 'development'

config =
  development:
    app:
      port: 4000
      pulsarPort: 4001
      ssl: false
    mongo:
      host: 'mongodb://localhost:27017/guru-dev'

  production:
    app:
      port: 443
      pulsarPort: 4001
      ssl:
        key: "../../certs/privatekey.pem"
        cert: "../../certs/livechathost.com.crt"
        ca: ["../../certs/gd_bundle.crt"]
    mongo:
      host: 'mongodb://guru:gk31Ql8151BTOS1@ds035137.mongolab.com:35137/guru-dev'

module.exports = config[environment]
