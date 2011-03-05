// Sets up the stars to match the data when the page is loaded.
jQuery(function () {
    var checkedId = jQuery('form.rating > input:checked').attr('id');
    jQuery('form.rating > label[for=' + checkedId + ']').prevAll().andSelf().addClass('bright');
});

jQuery(document).ready(function() {

    // submit form after each change
    $('.submittable').live('change', function() {
      $(this).parents('form:first').submit();
    });
    
    // Makes stars glow on hover.
    jQuery('form.rating > label').hover(
        function() {    // mouseover
            jQuery(this).prevAll().andSelf().addClass('glow');
        },function() {  // mouseout
            jQuery(this).siblings().andSelf().removeClass('glow');
    });

    // Makes stars stay glowing after click.
    jQuery('form.rating > label').click(function() {
        jQuery(this).siblings().removeClass("bright");
        jQuery(this).prevAll().andSelf().addClass("bright");
    });
    
});