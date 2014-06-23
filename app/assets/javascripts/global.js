var trackClick = function(url, label) {
    ga('send', {
        'hitType': 'event',
        'eventCategory': 'link',
        'eventAction': 'click',
        'eventLabel': label,
        'hitCallback' : function () { document.location = url; }
    });
    return false;
}
