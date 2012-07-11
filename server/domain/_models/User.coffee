db = require 'mongoose'
{Schema} = db

user = new Schema

  firstName: 
    type: String
    default: ""

  lastName:
    type: String
    default: ""

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

  websites:
    type: [String]
    default: []

  departments:
    type: [String]
    default: []

module.exports = user
