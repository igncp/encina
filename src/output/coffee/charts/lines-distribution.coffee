define 'charts/lines-distribution', ['charts/common'], (common)->
  graph = {}

  graph.render = (data)->
    width = 800
    height = 400
    
    margin = {left: 160, top: 100}
    floor = height - margin.top * 2
    barWidth = (width - margin.left) / data.length
    barHeight = 7
    barYFn = (d)-> floor - barHeight * d
    barHeightFn = (d)-> d * barHeight
    
    colorsArr = ['#323247','#7C7CC9','#72B66C','#429742']
    color = common.createColorsScale  colorsArr, data
    
    svg = d3.select('#chart-lines-distribution').append('svg')
      .attr({width: width, height: height})
    
    chart = svg.append('g')
      .attr({transform: 'translate(' + margin.left + ',' + \
        margin.top + ')'})

    x = d3.scale.linear()
      .domain([0.5,data.length + .5])
      .range([1,barWidth * data.length])

    y = d3.scale.linear()
      .domain([0, d3.max(data, (d)-> console.log 'd', d; 1)])
      .rangeRound([0, -1 * barHeight * d3.max(data)])

    xAxis = d3.svg.axis().scale(x)
      .orient('bottom').ticks(data.length)
    yAxis = d3.svg.axis().scale(y)
      .orient('left').ticks(5)
    
    chart.append('g')
      .attr({'transform': 'translate(0,' + floor + ')', class: 'x-axis axis'})
      .call(xAxis)
      .append('text').attr('transform', 'translate(' + barWidth * data.length / 2 + ' ,0)')
      .attr('class', 'x-axis-label')
      .attr('y', 40).attr('font-size', '1.3em').style({'text-anchor': 'end'}).text('Number')

    chart.append('g')
      .attr({'transform': 'translate(0,' + floor + ')', class: 'x-axis axis'})
      .call(yAxis)
      .append('text')
      .attr('transform', 'translate(-30,' + String((-1) * (height - 60) / 2) + ')')
      .attr('y', 40)
      .attr('font-size', '1.3em')
      .style({'text-anchor': 'end'})
      .text('Value')

    drawBars = ->
      chart.selectAll('rect')
        .data(data).enter().append('rect')
        .attr('x', (d, i)-> barWidth * i)
        .attr('y', barYFn).attr('width', barWidth)
        .attr('height', barHeightFn )
        .attr('fill', (d)-> color(d))
    console.log 'llega2'
    drawBars()

  graph