define 'charts/structure-radial-graph', ['charts/defaults/radial-graph'], (chart)->
  render = (data, id)->
    graph = chart()
    transformedData = graph.transformTreeDataToNodesAndLinks data
    graph.render transformedData, id, 'TITLE'

  render