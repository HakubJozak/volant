Volant.PlacementInfoView = Ember.View.extend
  templateName: 'placement_info'

  applyForm: Ember.computed.alias('controller.applyForm')
  workcamp: Ember.computed.alias('controller.workcamp')  

  relevantFreePlaces: (->
    if @get('applyForm.male')
      Ember.Object.create
        empty: @get('workcamp.free_places_for_males') > 0
        confirmed: @get('workcamp.free_places_for_males')
        asked: @get('workcamp.asked_for_places_males')
    else
      Ember.Object.create
        empty: @get('workcamp.free_places_for_females') > 0
        confirmed: @get('workcamp.free_places_for_females')
        asked: @get('workcamp.asked_for_places_females')
  ).property('applyForm.male','workcamp.free_places','workcamp.free_places_for_females','workcamp.free_places_for_males')

  placementPopup: (->
     free = @get('workcamp.free_places')
     males = @get('workcamp.free_places_for_males')
     females = @get('workcamp.free_places_for_females')
     asked = @get('workcamp.asked_for_places_males')
     asked_males = @get('workcamp.asked_for_places_males')
     asked_females = @get('workcamp.asked_for_places_females')
    
     """
        <table class='table table-condensed free-places-popover'>
          <tr>
           <th></th>
           <th>Confirmed</th>
           <th>Asked</th>
          </tr>
          <tr>
           <th><i class='fa fa-user'></i></th>
           <td>#{free}</td>
           <td>#{asked}</td>
          </tr>
          <tr>
           <th><i class='fa fa-female'></i></th>
           <td>#{females}</td>
           <td>#{asked_females}</td>
          </tr>
          <tr>
           <th><i class='fa fa-male'></i></th>
           <td>#{males}</td>
           <td>#{asked_males}</td>
          </tr>
        </table>
      """
  ).property('workcamp.free_places')

  didInsertElement: ->
    @$('[data-toggle="popover"]').popover
      html: true
      title: 'Free Places'
      content: =>
        @get('placementPopup')
    
    

