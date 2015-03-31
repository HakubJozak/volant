Volant.VolunteerMixin = Ember.Mixin.create
  male: Ember.computed.equal('gender','m')
  female: Ember.computed.equal('gender','f')
  teenage: Ember.computed.lt('age',18)

  name: (->
    first = @get('firstname')
    last = @get('lastname')
    "#{last} #{first}"
    ).property('firstname', 'lastname')

  for_email: ->
    @_super('name','male','female','teenage')
