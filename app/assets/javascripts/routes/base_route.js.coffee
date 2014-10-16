Volant.BaseRoute = Ember.Route.extend({
  afterModel: (model,transition) ->
    if title = @get('title')
      $(document).attr('title', "#{title.call(this,model)} - Volant")
    else
      'Volant'

  setupController: (controller,model) ->
    @setupPagination(controller,model)
    @_super(controller,model)

  # not an Ember hook, normal method called from setupController hook
  setupPagination: (controller,model) ->
    modelType = model.get('type')
    hash = @store.typeMapFor(modelType).metadata.pagination
    controller.set( 'controllers.pagination.model', Ember.Object.create(hash) )

})
