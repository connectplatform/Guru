describe "billing suite", ->
  billing = require "../../../../app/server/billing"
  chai = require "chai"
  expect = chai.expect

  describe "accountInGoodStanding", ->
    it "should be defined", () ->
      expect(billing.accountInGoodStanding).to.be.a("function")

    it "should return correct result", (done) ->
      data = {}

      callback = (err, result) ->
        expect(err).to.equal(null)
        expect(result.goodStanding).to.equal(true)
        done()

      billing.accountInGoodStanding data, callback

  describe "syncSubscription", ->
    it "should be defined", ->
      expect(billing.syncSubscription).to.be.a("function")

    it "should return correct result", (done) ->
      data = {}

      callback = (err, result) ->
        expect(err).to.equal(null)
        expect(result).to.be.a("object")
        done()

      billing.syncSubscription data, callback

  describe "createAccount", ->
    it "should be defined", ->
      expect(billing.createAccount).to.be.a("function")

    it "should return correct result", (done) ->
      data = {}

      callback = (err, result) ->
        expect(err).to.equal(null)
        expect(result).to.be.a("object")
        done()

      billing.createAccount data, callback

  describe "getAccount", ->
    it "should be defined", ->
      expect(billing.getAccount).to.be.a("function")

    it "should return correct result", (done) ->
      data = {}

      callback = (err, result) ->
        expect(err).to.equal(null)
        expect(result)
        .to.have.property("data")
        .to.have.property("account")
        .to.have.property("hosted_login_token")

        done()

      billing.getAccount data, callback