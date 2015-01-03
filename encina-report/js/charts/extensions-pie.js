(function() {
  define('charts/extensions-pie', ['charts/defaults/pie'], function(pie) {
    var render;
    render = function(data) {
      data = _.sortBy(data, function(obj) {
        return (-1) * obj.count;
      });
      return pie.render(data, '#chart-extensions-pie');
    };
    return render;
  });

}).call(this);
