Volant.WorkcampAssignmentInsideWorkcampController = Ember.ObjectController
  needs: ['workcamp']
  isCurrentWorkcamp: Ember.computed.equal('controllers.workcamp.id','workcamp.id')
