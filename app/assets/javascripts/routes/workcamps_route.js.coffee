Volant.WorkcampsRoute = Volant.BaseRoute.extend
  default_filter: -> { type: 'outgoing' }
  newWorkcampType: 'outgoing'
  toolbar: 'workcamps/toolbar'

  queryParams:
    order: { refreshModel: true }
    sortAscending: { refreshModel: true }

  model: (params) ->
    filter = @default_filter()
    filter.q = params.query
    filter.p = params.page
    filter.order = params.order
    filter.asc = params.sortAscending
    filter.year = params.year unless params.year == 'All'
    filter.per_page = @controllerFor('pagination').get('perPage')

    attrs = [ 'from','to','min_duration','max_duration','age'
              'free', 'free_males', 'free_females' ]

    for attr in attrs
      if params[attr]
        filter[attr] = params[attr]

    controller = @controllerFor(@routeName)
    filter['tag_ids'] = controller.get('tags').mapBy('id')
    filter['workcamp_intention_ids'] =controller.get('workcamp_intentions').mapBy('id')
    filter['country_ids'] = controller.get('countries').mapBy('id')
    filter['organization_ids'] = controller.get('organizations').mapBy('id')

    @store.find 'workcamp', filter #, (wc) ->
      # debugger
      # (!params.year? or wc.year == params.year) and
      # (!params.from? or wc.from >= params.from) and
      # (!params.to? or wc.to <= params.to)

  title: -> "Workcamps"

  setupController: (controller,model,queryParams) ->
    @_super(controller, model,queryParams)
    controller.set 'newWorkcampType',@get('newWorkcampType')

  actions:
    new: (type) ->
      @transitionTo 'workcamps.new',type

    createApplyForm: (wc) ->
      attrs =
        workcamp: wc.get('model')
        fee: 0
        type: 'incoming'
        workcampToAssign: wc

      form = @store.createRecord 'apply_form',attrs
      # @transitionTo 'new_apply_form',{ type: 'incoming', queryParams: { fee: 333 } }
      @transitionTo '/apply_forms/incoming/new?fee=333'
      false

    rollback: ->
      @controllerFor(@routeName).set 'editingVisible',false
      for wc in @currentModel.filterBy('isDirty',true)
        wc.rollback()
      @flash_info 'All workcamps reverted.'  
 
    save: ->
      @controllerFor(@routeName).set 'editingVisible',false
      msg = 'Saving...'
      promises = @currentModel.filterBy('isDirty',true).map (wc) -> wc.save()
      @flash_info(msg)  

      Ember.RSVP.all(promises).then (results) =>
        for r in results
          if r.state == 'fullfilled'
            workcamp = r.value      
            msg += "#{workcamp.get('code')} saved."
          else
            msg += "#{r.reason}."
      false

    yearChanged: ->
      @refresh()
      false
