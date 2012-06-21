environment = process.env.NODE_ENV or 'development'

config =
  development:
    app:
      port: 4000
    mongo:
      host: 'mongodb://localhost:27017/guru-dev'

  production:
    app:
      port: 80
    mongo:
      host: 'mongodb://guru:oIO7=1_85-7y||~@ds033767.mongolab.com:33767/guru-prod'

module.exports = config[environment]
