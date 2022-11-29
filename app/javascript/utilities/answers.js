$(document).on('turbolinks:load', function () {
    $('.answers-list').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hide');
        $('#answer-' + answerId + ' .delete-file').removeClass('hide');
    })
});
