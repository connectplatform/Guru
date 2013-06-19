{select} = config.require 'lib/util'
initServices = config.require 'load/initServices'
{print} = require 'law'

# this should be moved to Law
deepSearch = (services, selection) ->
  stacks = select services, selection...
  found = []

  walk = (name, selection) ->
    result = selection.map (s) ->

      # don't repeat deep lookups, don't complicate things that have no data
      if (s is name) or (s in found) or not services[s] or services[s].length < 2
        s
      else
        return walk s, services[s]

    found.push selection
    return result

  Object.map stacks, walk

module.exports = (only...) ->
  initServices()
  filterList = print config.services
  filterList = deepSearch filterList, only if only.length > 0
  console.log filterList
  process.exit()
