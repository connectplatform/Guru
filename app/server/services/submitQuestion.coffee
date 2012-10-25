sendEmail = config.require 'services/email/sendEmail'
render = config.require 'services/templates/renderTemplate'

module.exports = ({emailData, customerData}, done) ->
  for field in ['email', 'body', 'subject']
    return done "Missing required field: #{field}" unless emailData[field]

  addedInfo = ([field, data] for field, data of customerData)
  emailData.body += '<br/><br/>User Data:'
  emailData.body += render 'table', {headers: ['Field', 'Value'], rows: addedInfo}

  sendingOptions =
    to: config.app.mail.options.support
    from: config.app.mail.options.from
    replyTo: emailData.email
    subject: emailData.subject

  sendEmail emailData.body, sendingOptions, done
