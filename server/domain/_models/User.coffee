db = require 'mongoose'
{Schema} = db

user = new Schema

  firstName: String

  lastName: String

  email:
    type: String
    required: true
    index:
      unique: true

  password:
    type: String
    required: true

  role:
    type: String
    required: true

  websites: [String]

  departments: [String]

module.exports = user
