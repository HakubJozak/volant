Volant.IndexController = Ember.ObjectController.extend
  queryParams: ['year']
  year: Ember.computed.alias('controllers.application.year')

  needs: ['application']
  starred: Ember.computed.union('model.starred_apply_forms','model.starred_workcamps')

  # TODO: DRY with ListController
  yearObserver: ( ->
    Ember.run.once(this,'send','yearChanged');
  ).observes('year')
