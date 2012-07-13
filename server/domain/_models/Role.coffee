db = require 'mongoose'
{Schema} = db

role = new Schema

  name:
    type: String
    required: true

module.exports = role