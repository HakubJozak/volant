Volant.WorkcampApplyFormsController = Ember.ArrayController.extend
  needs: ['workcamp']
  sortProperties: ['currentWorkcamp','state']

  sortFunction: (a,b) ->
    if a && a.isState && b && b.isState
      a.priority - b.priority    
    else
      wc = @get('controllers.workcamp.id')
      aa = 0
      bb = 0
      aa += 10000 if a? && a.get('id') == wc
      bb += 10000 if b? && b.get('id') == wc
      bb - aa
