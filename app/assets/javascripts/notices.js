var radio_label = {
    'radio-notices-email' : 'notices-home-email',
    'radio-notices-phone' : 'notices-home-phone'
};

$(document).ready(function() {
    $('.radio-notices-type').change(function (e) {
        e.preventDefault();
        ga('send', {
            'hitType': 'event',
            'eventCategory': 'button',
            'eventAction': 'click',
            'eventLabel': radio_label[this.id] });
        $.ajax({ url: radio_subforms[this.id],
                 success: function (data) {
                     $('#notices-subform').fadeOut('slow', function() {
                         $('#notices-subform').html(data);
                         $('#notices-subform').fadeIn('slow', function () {
                             scroll_subform();
                         });
                     });
                 }});
    });
});

function scroll_subform () {
    var y = $('#notices-subform').offset().top - 
        parseInt($('body').css('padding-top').replace('px', ''), 10);
    $('html,body').animate({ scrollTop: y }, 'slow');
}
