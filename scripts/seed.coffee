require '../app/config'
seed = config.require 'policy/sampleData'

seed (err, data) ->
  console.log 'Error: ', err if err?
  console.log "Created #{data.map((a)->a.length).reduce((l, r)->l+r)} records."
  process.exit()
