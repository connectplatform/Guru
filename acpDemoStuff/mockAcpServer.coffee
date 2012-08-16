connect = require 'connect'
querystring = require 'querystring'

acpData = {
  someField:
    firstSubfield: 'first subvalue'
    secondSubfield: 'another subvalue'
  anotherField: 'another value'
}

referrerData = {
  customerId: '1'
  websiteUrl: 'http://www.example.com'
}

console.log querystring.stringify referrerData

response = (req, res) ->
  query = querystring.parse req._parsedUrl.query
  if (query.customerId == referrerData.customerId) && (query.referrer == referrerData.referrer)
    res.end JSON.stringify acpData
testServer = connect().use(response).listen 8675
console.log 'listening on port 8675'
