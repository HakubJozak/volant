$(document).ready( function() {

  $('html').on('change', '#vt-year-selector select', function() {
      console.info('hi')
      $(this).closest('form').submit()
  });

    $('[data-popover]').popover({
	html: true,
	placement: 'left',
	title:
	'Free Places'})

});


    // @$().popover
    //   html: true
    //   title: 'Free Places'
    //   placement: 'left'
    //   content: =>
    //     @get('placementPopup')

