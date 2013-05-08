should = require 'should'
easyxml = require 'easyxml'
xml2js = require 'xml2js'
fs = require 'fs'
{join} = require 'path'

describe 'EasyXml', ->

  before ->
    @accountData =
      account_code: 'foo'
      email: 'foo@bar.com'

    @testResult = (result) ->
      result.replace(/\s/g, '').should.eql '<account><account_code>foo</account_code><email>foo@bar.com</email></account>'

  it 'should serialize properly', ->
    @testResult easyxml.render @accountData, 'account'

describe 'xml2js', ->

  it 'should deserialize properly', (done) ->
    file = join config.paths.data, 'sampleData/sampleXml.xml'
    console.log 'file', file
    sampleXml = fs.readFileSync file, 'utf8'

    parser = new xml2js.Parser(explicitArray: false, mergeAttrs: true)
    parser.parseString sampleXml, (err, data) ->
      should.not.exist err
      should.exist data?.account?.account_code
      data.account.account_code.should.eql 'example_account_code'
      data.account.href.should.eql 'http://a_shop.recurly.com/v2/accounts/example_account_code'
      done()
