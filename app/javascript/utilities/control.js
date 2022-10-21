import $ from "jquery"
window.$ = $; // to get jQuery

$(document).on('turbolinks:load', function(){
    $('.answers-list').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hide');
    })

    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).addClass('hide');
        $('form#edit-question').removeClass('hide');
    })
});
