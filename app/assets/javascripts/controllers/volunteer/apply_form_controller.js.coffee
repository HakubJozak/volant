Volant.VolunteerApplyFormsController = Ember.ArrayController.extend
  needs: ['volunteer']
  sortAscending: false
  sortProperties: ['createdAt']
  # model: (->
  #   id = @get('controllers.volunteer.id')     
  #   @store.find('apply_form',volunteer_id: id,order: 'created_at')
  # ).property('controllers.volunteer.id')  
          
