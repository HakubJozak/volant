Volant.IndexController = Ember.ObjectController.extend
  starred: Ember.computed.union('model.starred_apply_forms','model.starred_workcamps')
