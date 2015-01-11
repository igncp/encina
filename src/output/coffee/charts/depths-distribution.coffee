define 'charts/depths-distribution', ['charts/defaults/distribution-bars'], (dist)->
  render = (data, cb)->
    dist().render data, {
      elId: 'chart-depths-distribution'
      xLabel: 'Depth level'
      xTitle: 'level(s)'
      xProp: 'depthLevel'
    }

  render