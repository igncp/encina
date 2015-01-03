(function() {
  define('charts/lines-distribution', ['charts/common'], function(common) {
    var graph;
    graph = {
      vars: {},
      dom: {},
      scales: {}
    };
    graph.setCg = function() {
      return graph.cg = {
        width: $('#chart-lines-distribution').width(),
        height: 400,
        margin: {
          left: 160,
          bottom: 100,
          top: 10
        },
        colorsArr: ['#323247', '#7C7CC9', '#72B66C', '#429742']
      };
    };
    graph.setVars = function() {
      graph.vars.filesWithZeroLines = false;
      if (graph.data[0].linesCount === 0) {
        graph.vars.filesWithZeroLines = graph.data[0].filesCount;
        graph.data.splice(0, 1);
      }
      graph.vars.maxLinesCount = d3.max(graph.data, function(d) {
        return d.linesCount;
      });
      graph.vars.maxFilesCount = d3.max(graph.data, function(d) {
        return d.filesCount;
      });
      graph.vars.verticalMargin = graph.cg.margin.top + graph.cg.margin.bottom;
      graph.vars.floor = graph.cg.height - graph.cg.margin.bottom * 2;
      graph.vars.barHeight = (graph.cg.height - graph.vars.verticalMargin) / graph.vars.maxFilesCount;
      return graph.vars.color = common.createColorsScale(graph.cg.colorsArr, graph.data, 'filesCount');
    };
    graph.setData = function(data) {
      return graph.data = data;
    };
    graph.createSlider = function() {
      d3.select('#chart-lines-distribution').append('div').append('p').attr('class', 'col-lg-12').attr('id', 'chart-lines-distribution-slider-title').text('Scale Modification (Logarithmic)');
      d3.select('#chart-lines-distribution').append('div').append('p').attr('class', 'col-lg-1').attr('id', 'chart-lines-distribution-slider-val-0');
      d3.select('#chart-lines-distribution').append('div').attr('id', 'chart-lines-distribution-slider').attr('class', 'col-lg-10');
      d3.select('#chart-lines-distribution').append('div').append('p').attr('class', 'col-lg-1').attr('id', 'chart-lines-distribution-slider-val-1');
      graph.dom.slider = $('#chart-lines-distribution-slider');
      return graph.dom.slider.slider({
        range: true,
        min: 1,
        max: graph.vars.maxLinesCount,
        values: [1, graph.vars.maxLinesCount],
        change: graph.draw,
        slide: graph.setSliderValues,
        stop: graph.setSliderValues
      });
    };
    graph.setSliderValues = function() {
      var transformToLogValue;
      transformToLogValue = function(sliderValue) {
        var factor, maxp, maxv, minp, minv;
        minp = 1;
        maxp = graph.vars.maxLinesCount;
        minv = Math.log(1);
        maxv = Math.log(graph.vars.maxLinesCount);
        factor = (maxv - minv) / (maxp - minp);
        return Math.exp(minv + factor * (sliderValue - minp));
      };
      graph.vars.sliderValues = graph.dom.slider.slider('values');
      return _.each(graph.vars.sliderValues, function(value, index) {
        var transformedValue;
        transformedValue = Math.floor(transformToLogValue(value));
        $('#chart-lines-distribution-slider-val-' + index).html(transformedValue);
        return graph.vars.sliderValues[index] = transformedValue;
      });
    };
    graph.setScales = function() {
      graph.scales.x = d3.scale.log().domain([graph.vars.sliderValues[0] - 0.5, graph.vars.sliderValues[1] + 1]).range([0, graph.cg.width - graph.cg.margin.left - 20]);
      return graph.scales.y = d3.scale.log().domain([0.5, graph.vars.maxFilesCount]).rangeRound([0, (-1) * (graph.cg.height - graph.vars.verticalMargin - 20)]);
    };
    graph.createChart = function() {
      var previousSvg;
      previousSvg = d3.select('#chart-lines-distribution svg');
      if (previousSvg) {
        previousSvg.remove();
      }
      graph.dom.svg = d3.select('#chart-lines-distribution').append('svg').attr({
        width: graph.cg.width,
        height: graph.cg.height
      });
      return graph.dom.chart = graph.dom.svg.append('g').attr({
        transform: 'translate(' + graph.cg.margin.left + ',' + graph.cg.margin.bottom + ')'
      });
    };
    graph.createAxis = function() {
      graph.dom.xAxis = d3.svg.axis().scale(graph.scales.x).orient('bottom').tickFormat(function(d) {
        var dString, digits, firstDigitOneOrFive;
        dString = d.toFixed(0).toString();
        digits = d % Math.pow(10, dString.length - 1);
        firstDigitOneOrFive = dString[0] === '1' || dString[0] === '5';
        if (digits === 0 && firstDigitOneOrFive) {
          return d;
        } else {
          return null;
        }
      });
      graph.dom.yAxis = d3.svg.axis().scale(graph.scales.y).orient('left').ticks(graph.vars.maxFilesCount < 11 ? graph.vars.maxFilesCount : 10).tickFormat(function(d) {
        var dString, digits, firstDigitOneOrFive;
        dString = d.toFixed(0).toString();
        digits = d % Math.pow(10, dString.length - 1);
        firstDigitOneOrFive = dString[0] === '1' || dString[0] === '5';
        if (digits === 0 && firstDigitOneOrFive) {
          return d;
        } else {
          return null;
        }
      });
      graph.dom.chart.append('g').attr({
        'transform': 'translate(0,' + graph.vars.floor + ')',
        "class": 'x-axis axis'
      }).call(graph.dom.xAxis).append('text').attr('transform', 'translate(' + (graph.cg.width - graph.cg.margin.left) / 2 + ' ,0)').attr('class', 'x-axis-label').attr('y', 40).attr('font-size', '1.3em').style({
        'text-anchor': 'end'
      }).text('Lines Count');
      return graph.dom.chart.append('g').attr({
        'transform': 'translate(0,' + graph.vars.floor + ')',
        "class": 'x-axis axis'
      }).call(graph.dom.yAxis).append('text').attr('transform', 'translate(-30,' + String((-1) * (graph.cg.height - graph.cg.margin.bottom) / 2) + ')').attr('y', 40).attr('font-size', '1.3em').style({
        'text-anchor': 'end'
      }).text('Files Count');
    };
    graph.createBars = function() {
      var dataUsed;
      dataUsed = graph.data.filter(function(item, index) {
        if (item.linesCount >= graph.vars.sliderValues[0] && item.linesCount <= graph.vars.sliderValues[1]) {
          return item;
        } else {
          return null;
        }
      });
      dataUsed = _.compact(dataUsed);
      return graph.dom.chart.selectAll('rect').data(dataUsed).enter().append('rect').attr('x', function(d, i) {
        return graph.scales.x(d.linesCount);
      }).attr('y', function(d) {
        return graph.scales.y(d.filesCount) + graph.vars.floor;
      }).attr('width', 2).attr('height', function(d) {
        return graph.scales.y(d.filesCount) * (-1);
      }).attr('fill', function(d) {
        return graph.vars.color(d.filesCount);
      }).append('title').text(function(d) {
        return d.linesCount + ' line(s), ' + d.filesCount + ' file(s)';
      });
    };
    graph.render = function(origData) {
      graph.setData(_.cloneDeep(origData));
      graph.setCg();
      graph.setVars();
      graph.createSlider();
      graph.setSliderValues();
      return graph.draw();
    };
    graph.draw = function() {
      graph.createChart();
      graph.setScales();
      graph.createAxis();
      return graph.createBars();
    };
    return graph;
  });

}).call(this);
