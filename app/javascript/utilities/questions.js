$(document).on('turbolinks:load', function () {
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).addClass('hide');
        $('form#edit-question').removeClass('hide');
        $('.question .delete-file').removeClass('hide');
    })
});
