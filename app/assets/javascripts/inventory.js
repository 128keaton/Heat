$(function() {
    function buildTable(data){
        let table = '<ul>';
        $.each(data, function(machine){
            $.each(data[machine], function(key, value){
                if (key == 'serial_number'){
                    let cell = "<li>Serial Number: " + value;
                    table += cell;
                }else if (key == 'inventory_location'){
                    let cell = " - Inventory Location: " + value + "</li>";
                    table += cell;
                }

            });
        });

        table += '</ul>';
        return table;
    }

    $('.find-form').submit(function (e) {
        e.preventDefault();
        let serialNumber = $('#find_serial_number').val();
        $.ajax({
            url: '/inventory/find',
            data: {
                'serial_number': serialNumber
            },
            type: 'POST',
            dataType: 'json',
            success: function(result){
                var title = " Result Found";
                if (result.length > 1 || result.length < 1 ){
                    title = " Results Found";
                }

                swal({
                    title: result.length + title,
                    html: buildTable(result)
                })

            }
        });
        return false;
    });
});