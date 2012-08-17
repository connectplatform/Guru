connect = require 'connect'
querystring = require 'querystring'

acpData = {
  name: 'Jim Morrison'
  ordersPlaced: 12
  order:
    orderNumber: 445997
    viewMessageLink: 'http://messagesystem.com/messages/445997'
    editOrderLink: 'http://messagesystem.com/messages/445997'
    timeRemaining: '4d 3h'
    deadline: '28 Jul 2012 21:18:27 GMT'
    status: 'In Progress'
    progress: '75%'
    writer:
      name: 'Misty Keith'
      ordersCompleted: 25
      ordersInProgress: 2
      rating: 7.5
  arrayForGoodMeasure: [
    'first'
    'second'
    'third'
    anObject:
      shouleBeTrue: true
      shouldBeNull: null
  ]
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
