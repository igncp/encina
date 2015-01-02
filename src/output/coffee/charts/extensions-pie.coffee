define 'charts/extensions-pie', ['charts/defaults/pie'], (pie)->
  render = (data)->
    data = _.sortBy data, (obj)-> (-1) * obj.count

    pie.render data, '#chart-extensions-pie'

  render