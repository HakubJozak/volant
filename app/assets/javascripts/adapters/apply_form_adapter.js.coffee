Volant.ApplyFormAdapter = Volant.ApplicationAdapter.extend
  ajaxError: (jqXHR) ->
    if jqXHR && jqXHR.status == 422
      json = Ember.$.parseJSON(jqXHR.responseText)
      errors = json.errors

      for attr of errors
        # Set errors on the nested records, for example:
        #  { errors:
        #  { 'payment.amount': [ "must not be blank" ] }
        #  { 'payment.returned_date': [ "must not be blank" ] }
        #
        # becomes
        #
        # { 'payment': { amount: [ "must not be blank" ],
        #                returned_date: [ 'must not be blank' ] }
        # }
        #
        if match = attr.match(/([a-z_]+)\.([a-z_]+)/)
          association = match[1]
          innerAttribute = match[2]
          errors[association] ||= {}
          errors[association][innerAttribute] = errors[attr]

      invalid_error = new DS.InvalidError(errors)
      invalid_error.full_rails_message = json.full_message
      return invalid_error
    else
      return @_super(jqXHR)


