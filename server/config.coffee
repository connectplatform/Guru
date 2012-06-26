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
      host: 'mongodb://nodejitsu:1f67dc62308acf2edc33fe00e9269ff5@staff.mongohq.com:10078/nodejitsudb764288183790'
      #host: 'mongodb://guru:oIO7=1_85-7y||~@ds033767.mongolab.com:33767/guru-prod' #mongolabs instance

module.exports = config[environment]
