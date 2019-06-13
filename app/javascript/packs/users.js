
$(document).on('turbolinks:load', () => {
  if (!$.fn.dataTable.isDataTable('#students-table')) {
    $('#students-table').DataTable({
      paging: true,
      dom: "<'row'<'col-sm-12 col-md-4 pt-4'B><'col-sm-12 col-md-4'l><'col-sm-12 col-md-4'f>>" +
      "<'row'<'col-sm-12'tr>>" +
      "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
      buttons: [
        'copyHtml5', 'csvHtml5', 'excelHtml5'
      ]
    })
  }

})