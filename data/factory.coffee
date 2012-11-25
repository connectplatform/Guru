Factory = require 'factory-worker'
{User, Account, Specialty, Website} = config.require('load/mongo').models

opcount = 1
Factory.define 'operator', User, {
    firstName: 'Op'
    lastName: 'Guy'
    email: -> "operator#{opcount++}@bar.com"
    sentEmail: true
    password: 'foobar'
    role: 'Operator'
    websites: ['foo.com']
  }

module.exports = Factory
