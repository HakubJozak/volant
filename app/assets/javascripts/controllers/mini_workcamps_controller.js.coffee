Volant.MiniWorkcampsController = Ember.ArrayController.extend({
  needs: ['application']
  year: Ember.computed.alias('controllers.application.year')

  year_observer: ( ->
    @send 'yearChanged'
  ).observes('year')


})
