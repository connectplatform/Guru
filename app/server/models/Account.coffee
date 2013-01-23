db = require 'mongoose'
{Schema} = db
{getString} = config.require 'load/util'

enums = config.require 'load/enums'

account = new Schema

  accountType:
    type: String
    enum: enums.accountTypes

account.path('_id').get getString

module.exports = account
