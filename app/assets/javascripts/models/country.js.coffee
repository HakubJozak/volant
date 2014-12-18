Volant.Country = DS.Model.extend
  name_en: DS.attr 'string'
  name_cz: DS.attr 'string'
  name: Ember.computed.alias('name_en')
  code: DS.attr 'string'
  tripleCode: DS.attr 'string'
  region: DS.attr 'string'
  zone: DS.attr 'string'
