Volant.IndexController = Ember.ObjectController.extend({
  starred: Ember.computed.union('model.starred_workcamps','model.starred_apply_forms')
})
