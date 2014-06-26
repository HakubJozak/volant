jQuery(function($){
  if (typeof($.datepicker) === 'object') {
    $.datepicker.regional['cz'] = {"monthNamesShort":["Led","\u00dano","B\u0159e","Dub","Kv\u011b","\u010cvn","\u010cvc","Srp","Z\u00e1\u0159","\u0158\u00edj","Lis","Pro,"],"changeMonth":true,"closeText":"Zav\u0159\u00edt","nextText":"Dal\u0161\u00ed","prevText":"P\u0159edchoz\u00ed","changeYear":true,"dateFormat":"dd.mm.yy","dayNames":["Ned\u011ble","Pond\u011bl\u00ed","\u00dater\u00fd","St\u0159eda","\u010ctvrtek","P\u00e1tek","Sobota"],"dayNamesMin":["Ne","Po","\u00dat","St","\u010ct","P\u00e1","So"],"dayNamesShort":["Ne","Po","\u00dat","St","\u010ct","P\u00e1","So"],"currentText":"Today","monthNames":["Leden","\u00danor","B\u0159ezen","Duben","Kv\u011bten","\u010cerven","\u010cervenec","Srpen","Z\u00e1\u0159\u00ed","\u0158\u00edjen","Listopad","Prosinec"]};
    $.datepicker.setDefaults($.datepicker.regional['cz']);
  }
  if (typeof($.timepicker) === 'object') {
    $.timepicker.regional['cz'] = {"ampm":false,"secondText":null,"minuteText":null,"hourText":null};
    $.timepicker.setDefaults($.timepicker.regional['cz']);
  }
});
$(document).ready(function() {
  $('input.date_picker').live('focus', function(event) {
    var date_picker = $(this);
    if (typeof(date_picker.datepicker) == 'function') {
      if (!date_picker.hasClass('hasDatepicker')) {
        date_picker.datepicker();
        date_picker.trigger('focus');
      }
    }
    return true;
  });
  $('input.datetime_picker').live('focus', function(event) {
    var date_picker = $(this);
    if (typeof(date_picker.datetimepicker) == 'function') {
      if (!date_picker.hasClass('hasDatepicker')) {
        date_picker.datetimepicker();
        date_picker.trigger('focus');
      }
    }
    return true;
  });
});