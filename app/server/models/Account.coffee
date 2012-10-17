db = require 'mongoose'
{Schema} = db

account = new Schema

  status:
    type: String
    enum: ['Trial', 'Active', 'Unpaid']

module.exports = account
