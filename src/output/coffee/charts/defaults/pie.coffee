define 'charts/defaults/pie', ['charts/common'], (common)->
  graph = {}

  graph.render = (data, elId, title, sliceTitleSuffix)->
    common.waitTillElPresent elId, ->
      width = 330
      height = 330
      margin = {
        top: 130
        bottom: 30
        left: 30
        right: 30
      }
      outerRadius = (width - margin.top) / 2
      color = d3.scale.category20c()
      arc = {}

      svg = d3.select '#' + elId
        .attr 'class', 'chart-pie'
        .append 'svg'
        .attr 'width', width
        .attr 'height', height

      svgTitle = svg
        .append 'g'
        .attr 'transform', 'translate(' + width / 2 + ',50)'
        .attr 'width', 100
        .attr 'height', 100
        .append 'text'
        .attr 'class', 'chart-pie-title'
        .text title

      chart = svg
        .append 'g'
        .attr 'transform', 'translate(' + width / 2 + ',' + height / 2 + ')'

      textTransform = (d)->
        d.outerRadius = outerRadius
        d.innerRadius = outerRadius / 2
        'translate(' + arc.centroid(d) + ')'

      mouseenter = (d)->
        d3.select this
          .select 'path'
          .transition().duration(400)
          .style {'stroke-width': '1px', fill: '#FFB61A'}

      mouseleave = (d)->
        d3.select this
          .select 'path'
          .transition().duration(400)
          .style {'stroke-width': '0.5px', fill: color(d.data.i)}

      common.createSvgFilterBlack(elId + '-drop-shadow-filter', chart, 3, .4)
      pie = d3.layout.pie().sort(null).value(((d)-> d.count))
      arc = d3.svg.arc().outerRadius(outerRadius)

      slices = chart
        .selectAll '.slice'
        .data pie(data)
        .enter()
        .append 'g'
        .attr 'class', 'slice'
        .on {mouseenter: mouseenter, mouseleave: mouseleave}
        .style 'filter', 'url(#' + elId + '-drop-shadow-filter)'

      path = slices
        .append 'path'
        .attr {fill: ((d,i)-> d.data.i = i; color(i)), d: arc, \
          'stroke-width': '0.5px'}

      labels = slices
        .filter (d)-> d.endAngle - d.startAngle > .3
        .append 'text'
        .attr {dy: '.35em', 'text-anchor': 'middle'}
        .attr 'transform', textTransform
        .text (d)-> d.data.name

      slices
        .append 'title'
        .text (d)-> d.data.name + ' (' + common.nbrWCommas(d.data.count) + \
          ' ' + sliceTitleSuffix + ') (' + d.data.percentage + '%)'


      slices.append('title').text((d)-> d.data.label)

  graph