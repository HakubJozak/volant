Volant.ApplyFormRoute = Volant.BaseRoute.extend(Volant.MessagingRouteMixin,{

  model: (params) ->
    @store.find('apply_form', params.apply_form_id)

  title: (model) -> "#{model.get('name')}"

  renderTemplate: ->
    @_super()
    @render('apply_form/page_up',into: 'application', outlet: 'page_up')
    @render('quick_save',into: 'application', outlet: 'item_controls')

  actions:
    accept: ->
      @open_message_for 'accept',  @modelFor('apply_form')

#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
