# http://emberjs.com/guides/models/#toc_store
# http://emberjs.com/guides/models/pushing-records-into-the-store/

Volant.ApplicationStore = DS.Store.extend({

})

# Override the default adapter with the `DS.ActiveModelAdapter` which
# is built to work nicely with the ActiveModel::Serializers gem.
Volant.ApplicationAdapter = DS.ActiveModelAdapter.extend({

})


Volant.ApplicationSerializer = DS.ActiveModelSerializer




# Transforms Date to avoid miss-match with rails date
# Volant.IsodateTransform  = DS.DateTransform.extend({
#   serialize: (date) ->
#     if date then moment(date).format("YYYY-MM-DD") else null
# })
