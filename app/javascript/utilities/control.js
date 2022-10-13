import $ from "jquery"
window.$ = $; // to get jQuery

$(document).on('turbolinks:load', function(){
    $('.answers-list').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        console.log(answerId);
        $('form#edit-answer-' + answerId).removeClass('hide');
    })
});
