Volant.DateView = Ember.TextField.extend

  type: 'date'
  hasFocus: false
  placeholderBinding: 'dateFormat'
  classNameBindings: [ ":form-control" ]
  dateFormat: 'YYYY-MM-DD'

  init: ->
    @_super()
    @updateValue()

  updateDate: (->
    ms = moment(@get('value'), @get('dateFormat'))
    @set('date', ms) if ms and ms.isValid()
  ).observes('value')

  updateValue: (->
    return if @get('hasFocus')
    date = @get('date')

    if date
      @set('value', moment(date).format(@get('dateFormat')))
  ).observes('date')

  focusIn: ->
    @set('hasFocus', true)

  focusOut: ->
    @set('hasFocus', false)
    @updateValue()
