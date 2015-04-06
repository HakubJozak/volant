Volant.WorkcampApplyFormsController = Ember.ArrayController.extend
  needs: ['workcamp']
  sortProperties: ['currentWorkcamp']

  sortFunction: (a,b) ->
    wc = @get('controllers.workcamp.id')    
    aa = 0
    bb = 0    
    aa += 10000 if a? && a.get('id') == wc
    bb += 10000 if b? && b.get('id') == wc
    bb - aa
