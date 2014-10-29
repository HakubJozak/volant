Volant.PaymentController = Volant.ObjectController.extend
  means: [
    {label: "Cash", id: 'CASH'},
    {label: "Bank", id: 'BANK'}
   ]

  show_return: false

  return_visible: Ember.computed.or('model.returned_amount','show_return')

  by_bank: (->
    @get('mean') == 'BANK'
  ).property('mean')

  actions:
    save: ->
      true

    force_show_return: ->
      @set('show_return',true)
      false
