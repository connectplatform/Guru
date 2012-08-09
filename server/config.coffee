environment = process.env.NODE_ENV or 'development'

config =
  development:
    app:
      port: 4000
      pulsarPort: 4001
    mongo:
      host: 'mongodb://localhost:27017/guru-dev'

  production:
    app:
      port: 80
      pulsarPort: 4001
    mongo:
      host: 'mongodb://guru:gk31Ql8151BTOS1@ds035137.mongolab.com:35137/guru-dev'

module.exports = config[environment]
