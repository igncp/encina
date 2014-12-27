define 'charts/lines-distribution', ['charts/common'], (common)->
  graph = {}

  graph.render = (origData)->
    data = _.cloneDeep origData
    
    filesWithZeroLines = false
    if data[0].linesCount is 0
      filesWithZeroLines = data[0].filesCount
      data.splice 0, 1

    maxLinesCount = d3.max(data, (d)-> d.linesCount)
    maxFilesCount = d3.max(data, (d)-> d.filesCount)
    width = 800
    height = 400
    
    margin = {left: 160, bottom: 100, top: 50}
    margin.vertical = margin.top + margin.bottom

    floor = height - margin.bottom * 2
    barHeight = (height - margin.vertical) / maxFilesCount
    
    colorsArr = ['#323247','#7C7CC9','#72B66C','#429742']
    color = common.createColorsScale  colorsArr, data
    
    slider = d3.select('#chart-lines-distribution')
      .append 'div'
      .attr 'id', 'slider'

    $('#slider').slider({
      range: true
      values: [0, 100]
    })
    
    svg = d3.select('#chart-lines-distribution')
      .append('svg')
      .attr({width: width, height: height})
    
    chart = svg.append('g')
      .attr({transform: 'translate(' + margin.left + ',' + \
        margin.bottom + ')'})

    x = d3.scale.log()
      .domain [0.5, maxLinesCount + 100.5]
      .range [0, width - margin.left - 20]

    y = d3.scale.log()
      .domain [0.5, maxFilesCount]
      .rangeRound [0, (-1) * (height - margin.vertical - 20)]

    xAxis = d3.svg.axis().scale(x)
      .orient('bottom')
      .tickFormat((d)->
        # Digits different than zero (except first one)
        dString = d.toFixed(0).toString()
        digits = d % Math.pow(10, (dString.length) - 1)
        firstDigitOneOrFive = dString[0] is '1' or dString[0] is '5'
        if digits is 0 and firstDigitOneOrFive then return d
        else return null
      )

    yAxis = d3.svg.axis().scale(y)
      .orient('left')
      .ticks if maxFilesCount < 11 then maxFilesCount else 10
      .tickFormat((d)->
        # Digits different than zero (except first one)
        dString = d.toFixed(0).toString()
        digits = d % Math.pow(10, (dString.length) - 1)
        firstDigitOneOrFive = dString[0] is '1' or dString[0] is '5'
        if digits is 0 and firstDigitOneOrFive then return d
        else return null
      )
    
    chart.append('g')
      .attr({'transform': 'translate(0,' + floor + ')', class: 'x-axis axis'})
      .call(xAxis)
      .append('text')
      .attr('transform', 'translate(' + (width - margin.left) / 2 + ' ,0)')
      .attr('class', 'x-axis-label')
      .attr('y', 40).attr('font-size', '1.3em')
      .style({'text-anchor': 'end'})
      .text('Lines Count')


    chart.append('g')
      .attr({'transform': 'translate(0,' + floor + ')', class: 'x-axis axis'})
      .call(yAxis)
      .append('text')
      .attr('transform', 'translate(-30,' + String((-1) * (height - margin.bottom) / 2) + ')')
      .attr('y', 40)
      .attr('font-size', '1.3em')
      .style({'text-anchor': 'end'})
      .text('Files Count')

    drawBars = ->
      chart.selectAll('rect')
        .data(data).enter().append('rect')
        .attr('x', (d, i)-> x(d.linesCount))
        .attr('y', (d)-> y(d.filesCount) + floor)
        .attr('width', 2)
        .attr('height', (d)-> y(d.filesCount) * (-1))
        .attr('fill', (d)-> color(d))
        .append 'title'
        .text (d)-> d.linesCount + ', ' + d.filesCount
    
    drawBars()

  graph