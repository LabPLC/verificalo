$(document).ready(function() {
    $('.btn-notices-home').click(function (e) {
        e.preventDefault();
        $('.btn-notices-home').addClass('btn-primary');
        $(this).addClass('btn-default');
        $(this).removeClass('btn-primary');
        $.ajax({ url: btn_forms[this.id],
                 success: function (data) {
                     $('#notices-form').fadeOut('slow', function() {
                         $('#notices-form').html(data);
                         $("#notices-form").fadeIn('slow', function () {
                             var y = $('#notices-form').offset().top - $('html').offset().top + $('html').scrollTop();
                             $('html').animate({ scrollTop: y }, 'slow');
                         });
                     });
                 }});
    });
});
