(function() {
  define('charts/common', function() {
    var common;
    common = {};
    common.createColorsScale = function(colors, data, key) {
      var c, colorScale, colorScaleFn;
      if (key == null) {
        key = null;
      }
      c = d3.scale.linear().domain(d3.extent(data, function(d) {
        if (key) {
          return d[key];
        } else {
          return d;
        }
      })).range([0, 1]);
      colorScale = d3.scale.linear().domain(d3.range(0, 1, 1.0 / colors.length)).range(colors);
      colorScaleFn = function(d) {
        return colorScale(c(d));
      };
      return colorScaleFn;
    };
    return common;
  });

}).call(this);
