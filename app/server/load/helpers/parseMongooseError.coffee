module.exports = (err, fields, modelName) ->
  return null unless err
  if err.code is 11000
    value = err.err.match(/"(.*)"/)?[1] # grab the name of the duplicate
    field = (f for f, v of fields when v is value)?[0]
    return "A #{modelName} with #{field}: '#{value}' already exists."

  if err.errors
    message = ""
    for field, info of err.errors
      message += "#{info.message}\n"
    return message
  else
    return "Could not save #{modelName}"
