$(document).ready(function() {
  $('tbody').load('/pings');

  $('th').live('click', function() {
    var sort = $(this).data('sort') || 'asc';
    var new_sort = (sort == 'asc') ? 'desc' : 'asc';
    var col = $(this).data('col');
    var req = '/pings?col='+col+'&sort='+sort;
    $(this).data('sort', new_sort);
    $('th').not(this).removeAttr('data-sort');
    $('th').not(this).removeClass(sort).removeClass(new_sort);
    $(this).removeClass(sort).addClass(new_sort);
    $('tbody').load(req);    
  });
});
