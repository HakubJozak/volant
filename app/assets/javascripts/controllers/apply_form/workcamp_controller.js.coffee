Volant.ApplyFormWorkcampController = Ember.ObjectController.extend
  needs: ['apply_form']
  applyForm: Ember.computed.alias('controllers.apply_form.model')
