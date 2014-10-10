# TODO - put these on some better place
Volant.SelectDataMixin = Ember.Mixin.create({
  countries: (->
     @store.find('country')).property()

  workcamp_intentions: (->
     @store.find('workcamp_intention')).property()

  organizations: (->
     @store.find('organization')).property()
})
