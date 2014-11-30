Volant.ImportChange = DS.Model.extend
  workcamp: DS.belongsTo('workcamp',async: true)
  field: DS.attr('string')
  value: DS.attr('string')
  diff: DS.attr('string')

  old_value: (->
    if field = @get('field')
      @get('workcamp').get(field)
    else
      null
  ).property('field','workcamp')
