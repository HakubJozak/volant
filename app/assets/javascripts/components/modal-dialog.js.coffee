Volant.ModalDialogComponent = Ember.Component.extend(
  actions:
    ok: ->
      @$(".modal").modal "hide"
      @sendAction "ok"
      return

  show: (->
    @$(".modal").modal().on "hidden.bs.modal", (->
      @sendAction "close"
      return
    ).bind(this)
    return
  ).on("didInsertElement")
)
