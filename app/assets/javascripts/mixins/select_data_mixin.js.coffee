Volant.SelectDataMixin = Ember.Mixin.create({
  organizations: (->
     @store.find('organization')).property()
})
