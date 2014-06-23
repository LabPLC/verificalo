var radio_label = {
    'radio-notices-email' : 'Recordatorios por correo electrónico',
    'radio-notices-phone' : 'Recordatorios por llamada telefónica'
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

var scroll_subform = function() {
    var y = $('#notices-subform').offset().top - 
        parseInt($('body').css('padding-top').replace('px', ''), 10);
    $('html,body').animate({ scrollTop: y }, 'slow');
}
