function sort(machine, el) {
    var sort = $(el).data('sort') || 'desc';
    var new_sort = (sort == 'asc') ? 'desc' : 'asc';
    var col = $(el).data('col');
    var req = '/pings/'+machine+'?col='+col+'&sort='+new_sort;
    $('tbody').load(req);      
    $(el).data('sort', new_sort);
    $('th').not(el).removeAttr('data-sort');
    $('th').not(el).removeClass(sort).removeClass(new_sort);
    $(el).removeClass(sort).addClass(new_sort);
}
