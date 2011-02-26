var curver_settings = {
  tl: { radius: 10 },
  tr: { radius: 10 },
  bl: { radius: 10 },
  br: { radius: 10 },
  antiAlias: true,
  autoPad: true
}


// Inititalize rounded corners for bubbles.
//Event.observe(window, 'load', function() {
    //  var myBoxObject = new curvyCorners(curver_settings, "rounded");
    //  myBoxObject.applyCornersToAll();
//});


function show_bubble(id, where_id) {
  var bubble = $(id);
  var where = $(where_id);

  if (bubble.visible() == false) {
    bubble.style.left = where.style.left + 'px';
    bubble.style.bottom =  (where.style.top) + 'px';
    bubble.appear({ duration: 0.4 });
  }
}

function hide_bubble(id) {
  if ($(id).visible()) {
    $(id).fade({ duration: 0.5 });
  }
}

function show_or_hide_menu(id) {
    item = $(id);

    if (item.visible()) {
        Effect.BlindUp(id, { duration: 0.3 });
        action = 'hide_menu_item';
    } else {
        Effect.BlindDown(id, { duration: 0.3 });
        action = 'show_menu_item';
    }

    var url = '/visibility/' + action + '?id=' + encodeURIComponent(id);

    new Ajax.Request(url, {
       method: 'post',
       onnSuccess: function(transport) {
       }
    });

}

function add_attachment(button,html) {
  button.up('li').insert({ after: html });
}


function remove_attachment(button) {
  button.up('li').remove();
}
