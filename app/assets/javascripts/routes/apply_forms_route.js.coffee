Volant.ApplyFormsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('apply_form', { p: params.page, year: params.year, q: params.query })

  title: -> "Applications"

  setupController: (controller,model) ->
    modelType = model.get('type')
    hash = @store.typeMapFor(modelType).metadata.pagination
    controller.set( 'controllers.pagination.model', Ember.Object.create(hash) )
    @_super(controller,model)

  renderTemplate: ->
    @render('_menu',into: 'application', outlet: 'menu')
    @render('apply_forms')

  actions:
    go_to_detail: (form) ->
      @transitionTo('apply_form',form)

    search: ->
      @refresh()
      false

    refresh: ->
      @refresh()
      false


})
