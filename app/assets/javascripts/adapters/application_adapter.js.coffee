Volant.ApplicationAdapter = DS.ActiveModelAdapter.extend
  coalesceFindRequests: true

  headers: (->
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  ).property().volatile()

  ajaxError: (jqXHR) ->
    invalid_error = @_super(jqXHR)

    if jqXHR && jqXHR.status == 422
      json = Ember.$.parseJSON(jqXHR.responseText)
      invalid_error.full_rails_message = json.full_message

    invalid_error
