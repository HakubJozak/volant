Volant.PaymentController = Volant.ObjectController.extend
  means: [
    {label: "Cash", id: 'CASH'},
    {label: "Bank", id: 'BANK'}
   ]

  show_return: false

  return_visible: Ember.computed.or('show_return','returned')

  by_bank: (->
    @get('mean') == 'BANK'
  ).property('mean')

  actions:
    clear_return_fields: ->
      @set('returned_amount',null)
      @set('returned_date',null)
      @set('return_reason',null)
      false

    remove_return_values: ->
      @get('model').clear_returned()

    force_show_return: ->
      @set('show_return',true)

      unless @get('returned_date')?
        @set('returned_date',new Date())

      unless @get('returned_amount')?
        @set 'returned_amount', @get('apply_form.fee')

      false
