connect = require 'connect'
{join} = require 'path'

app = connect()
app.use connect.static join(__dirname, '/public/')
app.listen 4003
