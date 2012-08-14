db = require 'mongoose'
{Schema} = db

specialty = new Schema

  name:
    type: String
    required: true
    index:
      unique: true

module.exports = specialty
