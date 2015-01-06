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

  common.waitTillElPresent = (elId, cb)->
    # This is not done with async's `until` because it stopped the loop
    wait = (wcb)->
      if document.getElementById(elId) then wcb()
      else setTimeout (-> wait(wcb)), 100
    
    wait(cb)

  common.createSvgFilterColor = (id, svg, deviation, slope, extra = false)->
    defs = svg.append 'defs'
    filter = defs.append('filter')
      .attr {id: id}
    filter.attr({width: '500%', height: '500%', x: '-200%', y: '-200%'}) if extra
    filter.append 'feOffset'
      .attr {result: 'offOut', in: 'SourceGraphic', dx: .5, dy: .5}
    filter.append('feGaussianBlur')
      .attr {result: 'blurOut', in: 'offOut', stdDeviation: deviation}
    filter.append('feBlend')
      .attr {in: 'SourceGraphic', in2: 'blurOut', mode: 'normal'}
    filter.append 'feComponentTransfer'
      .append 'feFuncA'
      .attr {type: 'linear', slope: slope}

  common.createSvgFilterBlack = (id, svg, deviation, slope)->
    defs = svg.append 'defs'
    filter = defs.append('filter')
      .attr({id: id, width: '500%', height: '500%', \
        x: '-200%', y: '-200%'})
    filter.append 'feGaussianBlur'
      .attr {in: 'SourceAlpha', stdDeviation: deviation}
    filter.append 'feOffset'
      .attr {dx: 1, dy: 1}
    filter.append 'feComponentTransfer'
      .append 'feFuncA'
      .attr {type: 'linear', slope: slope}
    feMerge = filter.append 'feMerge'
    feMerge.append 'feMergeNode'
    feMerge.append 'feMergeNode'
      .attr 'in', 'SourceGraphic'

  common