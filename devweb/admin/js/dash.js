var win = navigator.platform.indexOf('Win') > -1;
if (win && document.querySelector('#sidenav-scrollbar')) {
    var options = {
        damping: '0.5'
    }
    Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
}

$(document).on('click', '.nav-item', function() {
    $('.nav-item').children('a').removeClass('active');
    $(this).children('a').addClass('active');
});