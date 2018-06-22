$(function () {
    function buildTable(data) {
        let table = '<table>';
        let id = null;

        table += '<tr>'+
            '<th>Serial Number</th>'+
            '<th>Inventory Location</th>'+
            '<th>Remove</th>'+
            '</tr>';

        $.each(data, function (machine) {
            table += '<tr>';
            $.each(data[machine], function (key, value) {
                if (key === 'serial_number') {
                    table += "<td>" + value + '</td>';
                } else if (key === 'inventory_location') {
                    table += "<td>" + value + '</td>';
                } else if (key === 'id') {
                    id = value;
                }
            });
            table += '<td><a data-sweet-alert-confirm="Are you sure you want to remove this machine from inventory?" ' +
                'rel="nofollow" ' +
                'data-method="post" ' +
                'href="/inventory/remove/' + id +
                '"><i class="ic close red-icon"></i></a></td>' +
                '</tr>';
        });

        table += '</table>';
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
            success: function (result) {
                let title = " Result Found";
                if (result.length > 1 || result.length < 1) {
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