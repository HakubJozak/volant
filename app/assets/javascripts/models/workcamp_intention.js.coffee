Volant.WorkcampIntention = DS.Model.extend
  code: DS.attr 'string'
  description_en: DS.attr 'string'
  description_cz: DS.attr 'string'
  description: Ember.computed.alias('description_en')

  name: Ember.computed.alias('code')
