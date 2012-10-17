# I know how to ask the user for information

define ["templates/renderForm", 'helpers/util'], (renderForm, {random}) ->

  (options={}, fields, next) ->

    return next "Called renderForm with no fields." unless fields and fields.length > 0

    for f in fields
      f.default ||= ''

    options.name ||= random()
    options.submitText ||= 'Send'
    options.placement ||= '#content'

    $(options.placement).html renderForm {options: options, fields: fields}
    $("##{options.name}-form").find(':input').filter(':visible:first')

    $("##{options.name}-form").submit (evt) ->
      evt.preventDefault()

      # gather up form params into key/value object
      toObj = (obj, item) ->
        obj[item.name] = item.value
        return obj
      formParams = $(@).serializeArray().reduce toObj, {}

      next null, {action: 'receive', params: formParams}
