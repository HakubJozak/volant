$('html').on('change', '#vt-year-selector select', function() {
    console.info('hi')
    $(this).closest('form').submit()
});
