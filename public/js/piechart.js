google.load("visualization", "1", {packages:["corechart"]});
function drawChart(data) {
  var options = {
                  "legend"   : {"position": "none"},
                  "chartArea": { "width":  90, "height": 90},
                  "colors"   : ['#5da423','#c60f13'],
                  "height"   : 105,
                  "width"    : 105,
                  "fontName" : "Helvetica Neue",
                };
  var element = document.getElementById('piechart')
  var chart = new google.visualization.PieChart(element);
  chart.draw(data, options);
}
