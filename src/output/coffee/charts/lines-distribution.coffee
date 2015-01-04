define 'charts/lines-distribution', ['charts/common'], (common)->
  graph = {
    vars: {}
    dom: {}
    scales: {}
  }

  graph.setCg = ->
    graph.cg = {
      width: $('#chart-lines-distribution').width()
      height: 400
      margin: {left: 160, bottom: 100, top: 10}
      colorsArr: ['#323247','#7C7CC9','#72B66C','#429742']
    }
  
  graph.setVars = ->
    graph.vars.filesWithZeroLines = false
    if graph.data[0].linesCount is 0
      graph.vars.filesWithZeroLines = graph.data[0].filesCount
      graph.data.splice 0, 1

    graph.vars.maxLinesCount = d3.max(graph.data, (d)-> d.linesCount)
    graph.vars.maxFilesCount = d3.max(graph.data, (d)-> d.filesCount)
    graph.vars.verticalMargin = graph.cg.margin.top + graph.cg.margin.bottom
    graph.vars.floor = graph.cg.height - graph.cg.margin.bottom * 2
    graph.vars.barHeight = (graph.cg.height - graph.vars.verticalMargin) / graph.vars.maxFilesCount
    graph.vars.color = common.createColorsScale  graph.cg.colorsArr, graph.data, 'filesCount'

  graph.setData = (data)-> graph.data = data

  graph.createSlider = ->
    d3.select('#chart-lines-distribution')
      .append 'div'
      .append 'p'
      .attr 'class', 'col-lg-12'
      .attr 'id', 'chart-lines-distribution-slider-title'
      .text 'Scale Modification (Logarithmic)'
    d3.select('#chart-lines-distribution')
      .append 'div'
      .append 'p'
      .attr 'class', 'col-lg-1'
      .attr 'id', 'chart-lines-distribution-slider-val-0'
    d3.select('#chart-lines-distribution')
      .append 'div'
      .attr 'id', 'chart-lines-distribution-slider'
      .attr 'class', 'col-lg-10'
    d3.select('#chart-lines-distribution')
      .append 'div'
      .append 'p'
      .attr 'class', 'col-lg-1'
      .attr 'id', 'chart-lines-distribution-slider-val-1'
    graph.dom.slider = $('#chart-lines-distribution-slider')
    graph.dom.slider.slider({
      range: true
      min: 1
      max: graph.vars.maxLinesCount
      values: [1, graph.vars.maxLinesCount]
      change: graph.draw
      slide: graph.setSliderValues
      stop: graph.setSliderValues
    })

  graph.setSliderValues = ->
    transformToLogValue = (sliderValue)->
      minp = 1
      maxp = graph.vars.maxLinesCount
      minv = Math.log 1
      maxv = Math.log graph.vars.maxLinesCount

      # calculate adjustment factor
      factor = (maxv-minv) / (maxp-minp)
      Math.exp(minv + factor * (sliderValue-minp))

    graph.vars.sliderValues = graph.dom.slider.slider('values')
    _.each graph.vars.sliderValues, (value, index)->
      transformedValue = Math.floor transformToLogValue(value)
      $('#chart-lines-distribution-slider-val-' + index).html transformedValue
      graph.vars.sliderValues[index] = transformedValue

  graph.setScales = ->
    graph.scales.x = d3.scale.log()
      .domain [graph.vars.sliderValues[0] - 0.5, graph.vars.sliderValues[1] + 1]
      .range [0, graph.cg.width - graph.cg.margin.left - 20]

    graph.scales.y = d3.scale.log()
      .domain [0.5, graph.vars.maxFilesCount]
      .rangeRound [0, (-1) * (graph.cg.height - graph.vars.verticalMargin - 20)]

  graph.createChart = ->
    previousSvg = d3.select('#chart-lines-distribution svg')
    previousSvg.remove() if previousSvg
    graph.dom.svg = d3.select('#chart-lines-distribution')
      .append('svg')
      .attr({width: graph.cg.width, height: graph.cg.height})
    graph.dom.chart = graph.dom.svg.append('g')
      .attr({transform: 'translate(' + graph.cg.margin.left + ',' + \
        graph.cg.margin.bottom + ')'})
  
  graph.createAxis = ->
    graph.dom.xAxis = d3.svg.axis().scale(graph.scales.x)
      .orient('bottom')
      .tickFormat((d)->
        # Digits different than zero (except first one)
        dString = d.toFixed(0).toString()
        digits = d % Math.pow(10, (dString.length) - 1)
        firstDigitOneOrFive = dString[0] is '1' or dString[0] is '5'
        if digits is 0 and firstDigitOneOrFive then return d
        else return null
      )

    graph.dom.yAxis = d3.svg.axis().scale(graph.scales.y)
      .orient('left')
      .ticks if graph.vars.maxFilesCount < 11 then graph.vars.maxFilesCount else 10
      .tickFormat((d)->
        # Digits different than zero (except first one)
        dString = d.toFixed(0).toString()
        digits = d % Math.pow(10, (dString.length) - 1)
        firstDigitOneOrFive = dString[0] is '1' or dString[0] is '5'
        if digits is 0 and firstDigitOneOrFive then return d
        else return null
      )
    
    graph.dom.chart.append('g')
      .attr({'transform': 'translate(0,' + graph.vars.floor + ')', class: 'x-axis axis'})
      .call(graph.dom.xAxis)
      .append('text')
      .attr('transform', 'translate(' + (graph.cg.width - graph.cg.margin.left) / 2 + ' ,0)')
      .attr('class', 'x-axis-label')
      .attr('y', 40).attr('font-size', '1.3em')
      .style({'text-anchor': 'end'})
      .text('Lines Count')


    graph.dom.chart.append('g')
      .attr({'transform': 'translate(0,' + graph.vars.floor + ')', class: 'x-axis axis'})
      .call(graph.dom.yAxis)
      .append('text')
      .attr('transform', 'translate(-30,' + String((-1) * \
        (graph.cg.height - graph.cg.margin.bottom) / 2) + ')')
      .attr('y', 40)
      .attr('font-size', '1.3em')
      .style({'text-anchor': 'end'})
      .text('Files Count')

  graph.createBars = ->
    dataUsed = graph.data.filter((item, index)->
      if item.linesCount >= graph.vars.sliderValues[0] \
        and item.linesCount <= graph.vars.sliderValues[1] then return item
      else return null
    )
    dataUsed = _.compact dataUsed

    graph.dom.chart.selectAll('rect')
      .data(dataUsed)
      .enter()
      .append('rect')
      .attr('x', (d, i)-> graph.scales.x(d.linesCount))
      .attr('y', (d)-> graph.scales.y(d.filesCount) + graph.vars.floor)
      .attr('width', 2)
      .attr('height', (d)-> graph.scales.y(d.filesCount) * (-1))
      .attr('fill', (d)-> graph.vars.color(d.filesCount))
      .append 'title'
      .text (d)-> d.linesCount + ' line(s), ' + d.filesCount + ' file(s)'

  graph.render = (origData, cb)->
    common.waitTillElPresent 'chart-lines-distribution', ->
      graph.setData _.cloneDeep origData
      graph.setCg()
      graph.setVars()
      graph.createSlider()
      graph.setSliderValues()
      graph.draw()
      cb()

  graph.draw = ()->
    graph.createChart()
    graph.setScales()
    graph.createAxis()
    graph.createBars()
    
  graph