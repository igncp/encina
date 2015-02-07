define 'charts/lines-distribution', ['charts/defaults/distribution-bars'], (dist)->
  render = (data, cb)->
    dist().render data, {
      elId: 'chart-lines-distribution'
      xLabel: 'Lines Count'
      xTitle: 'line(s)'
      xProp: 'linesCount'
    }, cb

  render