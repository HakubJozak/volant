Volant.ApplyFormRoute = Volant.BaseRoute.extend({

  model: (params) ->
    @store.find('apply_form', params.apply_form_id)

  title: (model) -> "#{model.get('name')}"

  renderTemplate: ->
    @_super()
    @render('apply_form/page_up',into: 'application', outlet: 'page_up')
    @render('quick_save',into: 'application', outlet: 'item_controls')

  actions:
    accept: ->
      @store.find('email_template').then (templates) =>
        @controllerFor('email_templates').set('content', templates)

        apply_form = @modelFor('apply_form')
        user = @get('current_user.content')
        message = @store.createRecord('message', apply_form: apply_form, user: user)
        @controllerFor('message').set('content',message)

      @render 'message', into: 'application',outlet: 'modal'
      false

#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
