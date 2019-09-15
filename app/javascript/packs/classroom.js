$(document).on('turbolinks:load', () => {
  if (page.controller() === 'classrooms') {
    $('.custom-select').on('change', () => {
      $('#syncStatus').text('Needed')
      $('#syncButton').addClass('btn-danger')
      $('#syncButton').removeClass('btn-primary')
      $('#syncButton').text('School sync required. Click here to start.')
    })

    $('tr[data-controller]').off('click')

    $('tr[data-controller]').click((event) => {
      if (!event.target.classList.contains('btn')) {

        const controller = $(event.target.parentNode).data('controller')
        const id = $(event.target.parentNode).data('id')

        Turbolinks.visit(`/${controller}/${id}`)
      }
    })

    if (!$.fn.dataTable.isDataTable('#students-table')) {
      $('#students-table').DataTable({
        paging: false,
        dom: '<"row align-items-center"<"col d-flex "B><"col passwordCheck"><"col"fr>><"row"t>',
        buttons: [
          'copyHtml5', 'csvHtml5', 'excelHtml5'
        ]
      })
    }

    // Allow reset password checkbox
    $('div.passwordCheck').html('<div class="form-check-inline"><input class="form-check-inline" id="resetPasswordCheck" type="checkbox"></input><label class="form-check-label" for="resetPasswordCheck"> Reset Passwords?</label></div>')
    $('#resetPasswordCheck').on('click', () => {
      $('.password-col').toggleClass('d-none')
    })

    if (!$.fn.dataTable.isDataTable('#homework-table')) {
      $('#homework-table').DataTable({
        dom: 'rtp',
        'pageLength': 5,
        'language': {
          'emptyTable': 'No homeworks have been found'
        }
      })
    }

    if (!$.fn.dataTable.isDataTable('#classroom-table')) {
      $('#classroom-table').DataTable({
        'pageLength': 25,
        'language': {
          'emptyTable': 'No classrooms have been found'
        }
      })
    }
  }
})

if (!Turbolinks) {
  location.reload()
}

Turbolinks.dispatch('turbolinks:load')
