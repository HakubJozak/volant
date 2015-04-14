Ember.Handlebars.helper 'workcamp-assignment-position-info', (wa) ->
  title = "#{wa.get('position')}(#{wa.get('applyForm.currentAssignment.position')})"
  info = "#{wa.get('position')}. on the VEF. Currently active is #{wa.get('applyForm.currentAssignment.position')}."
  new Handlebars.SafeString "<sub title='#{info}'>#{title}</sub>"
