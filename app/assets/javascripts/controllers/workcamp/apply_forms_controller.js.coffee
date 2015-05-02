Volant.WorkcampApplyFormsController = Ember.ArrayController.extend
  needs: ['workcamp']
  sortProperties: ['currentWorkcamp','state']

  sortFunction: (a,b) ->
    if a && a.isState && b && b.isState
      order = ['confirmed', 'infosheeted', 'accepted', 'asked', 'paid', 'cancelled', 'rejected'] 
      -(order.indexOf(b.name) - order.indexOf(a.name))
    else
      wc = @get('controllers.workcamp.id')
      aa = 0
      bb = 0
      aa += 10000 if a? && a.get('id') == wc
      bb += 10000 if b? && b.get('id') == wc
      bb - aa
