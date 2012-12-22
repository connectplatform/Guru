# I know how to ask the user for information
define ["load/server", "templates/renderForm", "helpers/validateField", "helpers/notifyInline", "helpers/util"],
  (server, renderForm, validateField, notifyInline, {random, getType, formToHash}) ->

    (options={}, fields, receive) ->
      receive ||= ->

      console.log 'we are in renderform'

      # spit out an error if there's no fields
      unless fields and fields.length > 0
        console.log 'da fuck'
        server.log
          message: "Called renderForm with no fields."
          context:
            fields: fields
            options: options

        $(options.placement).html "Oops! There's no data for this form. The support team has been notified."
        return

      # defaults
      console.log('1')
      for f in fields
        f.defaultValue ||= ""

      options.name ||= random()
      options.submit ||= "group"
      options.submitText ||= "Send"
      options.placement ||= "#content"
      console.log('2')

      # render html
      $(options.placement).html renderForm {options: options, fields: fields}
      console.log('3')

      try
        $("##{options.name} input:first-child").focus()
      catch error
        console.log 'IE8 cant focus this for some reason:', error

      # field validations
      validatedFields = fields.filter (f) -> f.required or f.validation
      console.log('4')

      # perform inline validations
      validatedFields.map (field) ->
        console.log('5')
        {name} = field

        # trigger validation on linked fields
        if field.linked and getType(field.linked) is "Array"
          console.log 'validation triggers...'
          for linked in field.linked
            console.log 'linked: ', linked
            $("#{options.placement} .controls [name=#{linked}]").change ->
              $("#{options.placement} .controls [name=#{name}]").change()

        # trigger validation
        $("#{options.placement} .controls [name=#{name}]").change ->
          console.log 'trigger validation'
          error = validateField field, $(@).val()
          notifyInline options.placement, name, error

      # wire up submit
      console.log('options.name:', options.name)
      $("##{options.name}").submit (evt) ->
        evt.preventDefault()

        formParams = formToHash @

        # perform validations
        valid = true
        for field in validatedFields
          error = validateField field, formParams[field.name]
          notifyInline options.placement, field.name, error
          valid = false if error

        # done
        console.log 'valid:', valid
        return unless valid
        receive formParams
