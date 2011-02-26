function show_tags_popup(refresher, event) {
  if ($('tags-popup') == null) {
    $('body').insert(new Element('div',{ 'id':'tags-popup', 'style':'display:none' }));
    new Draggable('tags-popup');
  } else {
    $('tags-popup').hide();
  }

  popup = $('tags-popup');
  popup.style.right = Event.pointerX(event) + 'px';
  popup.style.top = Event.pointerY(event) + 'px';
  popup.update('Loading labels...');
  popup.appear({duration: 1.0});

  new Ajax.Request('/workcamps/tags_popup', {
    onSuccess: function(response) {
        $('tags-popup').update(response.body);
      }
  });


}
