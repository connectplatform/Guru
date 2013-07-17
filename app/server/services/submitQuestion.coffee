db = require 'mongoose'
{Website} = db.models

module.exports =
  dependencies:
    services: ['email/sendEmail', 'templates/renderTemplate']
  required: ['websiteUrl', 'emailData']
  service: (params, done, {services}) ->
    {websiteUrl, emailData} = params
    sendEmail = services['email/sendEmail']
    render = services['templates/renderTemplate']

    Website.findOne {url: websiteUrl}, {contactEmail: true}, (err, website) ->
      return done new Error "Could not find website: #{websiteUrl}" if err or not website

      # require all email fields
      for field in ['email', 'body', 'subject']
        return done new Error "Missing required field: #{field}" unless emailData[field]

      # render table of customer data
      customerData = ([field, data] for field, data of params when field isnt 'emailData')
      emailData.body += '<br/><br/>User Data:'
      emailData.body += render {template: 'table', options: {headers: ['Field', 'Value'], rows: customerData}}

      sendingOptions =
        to: website.contactEmail
        from: config.app.mail.options.from
        replyTo: emailData.email
        subject: emailData.subject

      sendEmail {body: emailData.body, options: sendingOptions}, done
