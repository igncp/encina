define 'charts/defaults/pie', ['charts/common'], (common)->
  graph = {}

  graph.render = (data, elId, cb)->
    common.waitTillElPresent elId, ->
      width = 200
      height = 200
      outerRadius = 100
      color = d3.scale.category20()
      arc = {}

      svg = d3.select '#' + elId
        .append 'svg'
        .attr 'width', width
        .attr 'height', height
        .append 'g'
        .attr 'transform', 'translate(' + width / 2 + ',' + height / 2 + ')'

      textTransform = (d)->
        d.outerRadius = outerRadius
        d.innerRadius = outerRadius / 2
        'translate(' + arc.centroid(d) + ')'

      pie = d3.layout.pie().sort(null).value(((d)-> d.count))
      arc = d3.svg.arc().outerRadius(outerRadius)

      slices = svg
        .selectAll '.slice'
        .data pie(data)
        .enter()
        .append 'g'
        .attr 'class', 'slice'

      path = slices
        .append 'path'
        .attr {fill: ((d,i)-> color(i)), d: arc}

      labels = slices
        .filter((d)-> d.endAngle - d.startAngle > .2)
        .append 'text'
        .attr {dy: '.35em', 'text-anchor': 'middle'}
        .attr 'transform', textTransform
        .text (d)-> d.data.name

      slices
        .append 'title'
        .text (d)-> d.data.name + ' (' + d.data.count + ')'

      slices.append('title').text((d)-> d.data.label)

      cb()

  graph