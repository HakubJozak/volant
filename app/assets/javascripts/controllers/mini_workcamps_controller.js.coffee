Volant.MiniWorkcampsController = Ember.ArrayController.extend({
  needs: ['application']

  year_observer: ( ->
    @send 'yearChanged'
  ).observes('year')


})
