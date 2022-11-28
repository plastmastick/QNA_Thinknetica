$(document).on('turbolinks:load', function(){
    $('.votes').on('ajax:success', function (e) {
        const resource = e.detail[0].resource;
        const id = e.detail[0].id;
        const rating = e.detail[0].rating;
        $('#rating-' + resource + '-id-' + id).html('Rating: ' + rating);
    })

        .on('ajax:error', function (e) {
            const errors = e.detail[0].errors;
            const resource = e.detail[0].resource;
            const id = e.detail[0].id;

            $.each(errors, function (index, value) {
                $(`#${resource}-${id}-errors`).html('<p class="alert alert-danger">' + value + '</p>');
            });
        });
});
