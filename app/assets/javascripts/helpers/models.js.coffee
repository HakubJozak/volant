Ember.Handlebars.helper "join-errors", (errors) ->
  errors.reduce ((previous, item, index) ->
    if index == 0
      "#{item.attribute} #{item.message}"
    else
      "#{previous}, #{item.attribute} #{item.message}"
  )
