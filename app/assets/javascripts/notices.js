var btn_label = {
    'btn-notices-home-email' : 'notices-home-email',
    'btn-notices-home-phone' : 'notices-home-phone'
};

$(document).ready(function() {
    $('.btn-notices-home').click(function (e) {
        e.preventDefault();
        ga('send', {
            'hitType': 'event',
            'eventCategory': 'button',
            'eventAction': 'click',
            'eventLabel': btn_label[this.id] });
        $('.btn-notices-home').removeClass('active');
        $(this).addClass('active');
        $.ajax({ url: btn_subforms[this.id],
                 success: function (data) {
                     $('#notices-subform').fadeOut('slow', function() {
                         $('#notices-subform').html(data);
                         $('#notices-subform').fadeIn('slow', function () {
                             scroll_subform();
                         });
                     });
                 }});
    });
    if (typeof btn_active != 'undefined') {
        $(btn_active).addClass('active');
        scroll_subform();
    }
});

function scroll_subform () {
    var y = $('#notices-subform').offset().top - 
        parseInt($('body').css('padding-top').replace('px', ''), 10);
    $('html,body').animate({ scrollTop: y }, 'slow');
}
