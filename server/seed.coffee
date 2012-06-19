async = require 'async'
mongo = require './mongo'
md5 = require 'md5'
User = mongo.model 'User'

Operators = [
  email: 'god@torchlightsoftware.com'
  password: 'foobar'
  role: 'admin'
  firstName: 'God'
,
  email: 'guru1@torchlightsoftware.com'
  password: 'foobar'
  role: 'Operator'
  firstName: 'First'
  lastName: 'Guru'
,
  email: 'guru2@torchlightsoftware.com'
  password: 'foobar'
  role: 'Operator'
  websites: 'test.com'
,
  email: 'guru3@torchlightsoftware.com'
  password: 'foobar'
  role: 'Operator'
  websites: 'test.com'
  departments: 'Sales'
]

mongo.wipe ->
  createUser = (user, cb) ->
    user.password = md5 user.password
    User.create user, -> cb()

  async.forEach boards, createBoard, (err) ->
    console.log 'Error: ', err if err?
    console.log 'Done'
    process.exit()
