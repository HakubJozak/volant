# for more details see: http://emberjs.com/guides/views/

Volant.TagSymbolSelectView = Ember.Select.extend
  classNames: ['form-control']
  content: Volant.FONT_AWESOME_ICON_NAMES.map (n) -> n.name

