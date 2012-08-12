$(document).ready(function() {
  $('tbody').load('/pings?col=updated_at&sort=desc');

  $('th').live('click', function() {
    var sort = $(this).data('sort') || 'desc';
    var new_sort = (sort == 'asc') ? 'desc' : 'asc';
    var col = $(this).data('col');
    var req = '/pings?col='+col+'&sort='+new_sort;
    $('tbody').load(req);      
    $(this).data('sort', new_sort);
    $('th').not(this).removeAttr('data-sort');
    $('th').not(this).removeClass(sort).removeClass(new_sort);
    $(this).removeClass(sort).addClass(new_sort);
  });
});
