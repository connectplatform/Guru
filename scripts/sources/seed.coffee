seed = config.require 'policy/sampleData'

module.exports = ->
  seed (err, data) ->
    console.log 'Error: ', err if err?
    #console.log "Full data: #{data}"
    console.log "Created #{data.map((a)->a.length).reduce((l, r)->l+r)} records."
    process.exit()
