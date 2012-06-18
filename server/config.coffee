environment = process.env.NODE_ENV or 'development'

config =
  development:
    app:
      port: 4000
    mongo:
      host: 'localhost'
      database: 'guru-dev'

  production:
    app:
      port: 80
    mongo:
      host: 'localhost'
      database: 'guru-dev'

module.exports = config[environment]
