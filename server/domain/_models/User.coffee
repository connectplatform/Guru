db = require 'mongoose'
{Schema} = db

validateRole = (role, cb) ->
  mongo = require '../../mongo'
  {Role} = mongo.models
  Role.find {}, (err, roles) ->
    for validRole in roles
      return cb true if role is validRole.name
    cb false

validateWebsite = (websiteName, cb) ->
  mongo = require '../../mongo'
  {Website} = mongo.models
  Website.find {}, (err, validWebsites) ->
    for validWebsite in validWebsites
      return cb true if websiteName is validWebsite.name
    cb false

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
    validate: [validateRole, "Invalid role"]

  websites:
    type: [String]
    default: []
#    validate: [validateWebsite, "Invalid website"]

  departments:
    type: [String]
    default: []

module.exports = user
