db = require 'mongoose'
{Schema} = db

enums = config.require 'load/enums'

account = new Schema

  status:
    type: String
    enum: enums.accountTypes

module.exports = account
