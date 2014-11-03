Volant.ApplyFormRoute = Volant.BaseRoute.extend({

  model: (params) ->
    @store.find('apply_form', params.apply_form_id)

  title: (model) -> "#{model.get('name')}"

  setupController: (controller,model,queryParmas) ->
    @_super(controller,model,queryParmas)
    @controllerFor('payment').set('content',model.get('payment'))


  renderTemplate: ->
    @_super()
    @render('apply_form/page_up',into: 'application', outlet: 'page_up')
    @render('quick_save',into: 'application', outlet: 'item_controls')

  actions:
    accept: ->
      @open_message_for 'accept',  @modelFor('apply_form')

    pay: ->
      form = @modelFor('apply_form')
      payment = @store.createRecord('payment',apply_form: form,amount: form.get('fee'),mean: 'CASH', received: new Date())
      @controllerFor('payment').set('content',payment)
      false


#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
