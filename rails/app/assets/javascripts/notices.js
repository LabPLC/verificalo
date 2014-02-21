$(document).ready(function() {
    $('.btn-notices-home').click(function (e) {
        e.preventDefault();
        $('.btn-notices-home').addClass('btn-primary');
        $(this).addClass('btn-default');
        $(this).removeClass('btn-primary');
        $.ajax({ url: btn_subforms[this.id],
                 success: function (data) {
                     $('#notices-subform').fadeOut('slow', function() {
                         $('#notices-subform').html(data);
                         $("#notices-subform").fadeIn('slow', function () {
                             var y = $('#notices-subform').offset().top - $('html').offset().top + $('html').scrollTop();
                             $('html').animate({ scrollTop: y }, 'slow');
                         });
                     });
                 }});
    });
});
