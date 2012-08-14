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

  specialties:
    type: [String]
    default: []

module.exports = website
