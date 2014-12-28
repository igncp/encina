define 'charts/common', ->
  common = {}

  # Returns a colors scale generated with a colors array and data
  common.createColorsScale = (colors, data, key = null)->
    c = d3
      .scale.linear()
      .domain(d3.extent(data, (d)-> if key then return d[key] else return d))
      .range([0,1])

    colorScale = d3
      .scale.linear()
      .domain(d3.range(0, 1, 1.0 / (colors.length)))
      .range colors
    
    colorScaleFn = (d)-> colorScale(c(d))
    colorScaleFn

  common