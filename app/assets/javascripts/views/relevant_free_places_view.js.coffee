Volant.RelevantFreePlacesView = Ember.View.extend
  attributeBindings: ['data-content']

  didInsertElement: ->
    free = @get('workcamp.free_places')
    males = @get('workcamp.free_places_for_males')
    females = @get('workcamp.free_places_for_females')
    asked = @get('workcamp.asked_for_places_males')
    asked_males = @get('workcamp.asked_for_places_males')    
    asked_females = @get('workcamp.asked_for_places_females')

    toggle = @$('[data-toggle="popover"]')
    toggle.popover
      html: true
      content: """
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
      title: 'Free Places'
    

  

