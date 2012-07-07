#TODO does this even need to exist?  It may be able to be folded into session.
face = (decorators) ->
  {operator: {allOperators}} = decorators

  faceValue =

    get: (id)->
      operator = id: id
      return operator

  allOperators faceValue

  return faceValue

schema =
  'operator:!{id}':
    nothingHere: 'Set' #TODO added to make this compile... unneeded
  operator:
    allOperators: 'Set'

module.exports = ['Operator', face, schema]