face = (decorators) ->
  {operator: {chats, allOperators}} = decorators

  faceValue =

    get: (id)->
      operator = id: id
      chats operator
      return operator

  allOperators faceValue

  return faceValue

schema =
  'operator:!{id}':
    chats: 'Set'
  operator:
    allOperators: 'Set'

module.exports = ['Operator', face, schema]