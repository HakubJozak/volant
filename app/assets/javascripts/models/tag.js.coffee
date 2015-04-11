Volant.Tag = DS.Model.extend
  name: DS.attr 'string'
  symbol: DS.attr 'string'  
  color: DS.attr 'string'
  textColor: DS.attr 'string'

  # legacy      
  text_color: Ember.computed.alias('textColor')

