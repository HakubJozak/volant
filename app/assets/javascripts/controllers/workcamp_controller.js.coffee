Volant.WorkcampController = Ember.ObjectController.extend
  needs: ['countriesSelect','workcampIntentionsSelect','organizationsSelect','tagsSelect','starred_apply_forms']

  publish_modes: [ { code: 'NEVER', label: 'Never' },
                   { code: 'ALWAYS', label: 'Always' },
                   { code: 'SEASON', label: 'During season' }
                  ]

  # isDirty: Ember.computed.or('model.isDirty','changed')
  #  changed: false
  # association_observer: (->
  #   @set('changed', true)
  # ).observes('model.organization','model.country','model.tags.@each','model.workcamp_intentions.@each')

  tagsAndIntents: Ember.computed.union('workcamp_intentions','tags')

  imported: Ember.computed.equal('state','imported')
  updated: Ember.computed.equal('state','updated')
  imported_or_updated: Ember.computed.or('imported','updated')

  set_country: (->
    unless @get('country')
      if @get('organization')
        @set('country', @get('organization.country'))
  ).observes('organization')
