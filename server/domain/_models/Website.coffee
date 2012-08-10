db = require 'mongoose'
{Schema} = db

website = new Schema

  name:
    type: String
    required: true
    index:
      unique: true

  url:
    type: String
    required: true
    index:
      unique: true

module.exports = website
