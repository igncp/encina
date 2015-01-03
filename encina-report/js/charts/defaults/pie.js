(function() {
  define('charts/defaults/pie', ['charts/common'], function(common) {
    var graph;
    graph = {};
    graph.render = function(data, elId) {
      var arc, color, height, labels, outerRadius, path, pie, slices, svg, textTransform, width;
      width = 200;
      height = 200;
      outerRadius = 100;
      color = d3.scale.category20();
      arc = {};
      svg = d3.select(elId).append('svg').attr('width', width).attr('height', height).append('g').attr('transform', 'translate(' + width / 2 + ',' + height / 2 + ')');
      textTransform = function(d) {
        d.outerRadius = outerRadius;
        d.innerRadius = outerRadius / 2;
        return 'translate(' + arc.centroid(d) + ')';
      };
      pie = d3.layout.pie().sort(null).value((function(d) {
        return d.count;
      }));
      arc = d3.svg.arc().outerRadius(outerRadius);
      slices = svg.selectAll('.slice').data(pie(data)).enter().append('g').attr('class', 'slice');
      path = slices.append('path').attr({
        fill: (function(d, i) {
          return color(i);
        }),
        d: arc
      });
      labels = slices.filter(function(d) {
        return d.endAngle - d.startAngle > .2;
      }).append('text').attr({
        dy: '.35em',
        'text-anchor': 'middle'
      }).attr('transform', textTransform).text(function(d) {
        return d.data.name;
      });
      slices.append('title').text(function(d) {
        return d.data.name + ' (' + d.data.count + ')';
      });
      return slices.append('title').text(function(d) {
        return d.data.label;
      });
    };
    return graph;
  });

}).call(this);
