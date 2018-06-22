function checkboxChange(checkbox){
    if (checkbox.is(':checked')){
        $(".role-form").clone().insertAfter(".role-form:last");
    }else{
        console.log('remove thing');
    }
}


$(document).ready(function () {

    function buildCheckBoxes(data) {
        let html = '';
        $.each(data['roles'], function (key, role) {
            html += '<label>' + role['name'] + '</label>'
            html += '<input type="checkbox" id="check-role" name="role[][id]" value="' + role['id'] + '" onclick="checkboxChange($(this))"><br>'
        });
        return html;
    }

    function isChecked(data) {
        $(".swal2-modal").each(function () {
            $(this).find(':checkbox').each(function () {
                let checkbox = $(this);
                $.each(data['checked'], function (key, role) {
                    if (checkbox.val() == role['id']) {
                        console.log(checkbox);
                        checkbox.prop('checked', true);
                    }
                    return false;
                });
            });
        });
    }



    $('#add-role').on('click', function (button) {
        let id = $(this).data('id');
        $.ajax({
            url: '/roles/list/' + id,
            type: 'POST',
            dataType: 'json',
            success: function (result) {
                console.log(result);
                swal({
                    title: 'Roles',
                    html: buildCheckBoxes(result)
                }).then((result) => {
                    console.log(result);
                });
                isChecked(result);
            }
        });
    })
});