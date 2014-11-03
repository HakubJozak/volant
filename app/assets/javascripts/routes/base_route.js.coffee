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
    if hash = @store.typeMapFor(modelType).metadata.pagination
      controller.set('controllers.pagination.model', Ember.Object.create(hash))

  flash_info: (msg) ->
    @controllerFor('application').set('flash', {type: 'success', message: msg })


  ajax_to_store: (url) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')
      data = { authenticity_token: csrf_token }

      try
        $.post url, data, (response) =>
          @store.pushPayload(response)
          resolve(response)
      catch e
        reject(e)

})
