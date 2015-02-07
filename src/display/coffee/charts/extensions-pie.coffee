define 'charts/extensions-pie', ['charts/defaults/pie'], (pie)->
  render = (data, id, title, sliceTitleSuffix)->
    pie.render data, id, title, sliceTitleSuffix

  render