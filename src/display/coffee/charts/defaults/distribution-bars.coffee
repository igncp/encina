define 'charts/defaults/distribution-bars', ['charts/common'], (common)->
  createChart = ->
    chart = {
      vars: {}
      dom: {}
      scales: {}
    }

    chart.setCg = (opts)->
      chart.cg = {
        width: $('#' + chart.vars.elId).width()
        height: 400
        margin: {left: 160, bottom: 100, top: 10}
        colorsArr: ['#323247','#7C7CC9','#72B66C','#429742']
        xLabel: opts.xLabel
        xProp: opts.xProp
        xTitle: opts.xTitle
      }
    
    chart.setVars = ->
      chart.vars.filesWithZeroLines = false
      if chart.data[0][chart.cg.xProp] is 0
        chart.vars.filesWithZeroLines = chart.data[0].filesCount
        chart.data.splice 0, 1

      chart.vars.maxXProp = d3.max(chart.data, (d)-> d[chart.cg.xProp])
      chart.vars.maxFilesCount = d3.max(chart.data, (d)-> d.filesCount)
      chart.vars.verticalMargin = chart.cg.margin.top + chart.cg.margin.bottom
      chart.vars.floor = chart.cg.height - chart.cg.margin.bottom * 2
      chart.vars.barHeight = (chart.cg.height - \
        chart.vars.verticalMargin) / chart.vars.maxFilesCount
      chart.vars.color = common.createColorsScale  chart.cg.colorsArr, chart.data, 'filesCount'

    chart.setData = (data)-> chart.data = data

    chart.createSlider = ->
      d3.select('#' + chart.vars.elId)
        .append 'div'
        .append 'p'
        .attr 'class', 'col-lg-12 slider-title'
        .attr 'id', chart.vars.elId + '-slider-title'
        .text 'Scale Modification (Logarithmic)'
      d3.select('#' + chart.vars.elId)
        .append 'div'
        .append 'p'
        .attr 'class', 'col-lg-1 slider-val-0'
        .attr 'id', chart.vars.elId + '-slider-val-0'
      d3.select('#'  + chart.vars.elId)
        .append 'div'
        .attr 'class', 'col-lg-10 slider'
        .attr 'id', chart.vars.elId + '-slider'
      d3.select('#' + chart.vars.elId)
        .append 'div'
        .append 'p'
        .attr 'class', 'col-lg-1 slider-val-1'
        .attr 'id', chart.vars.elId + '-slider-val-1'
      chart.dom.slider = $('#' + chart.vars.elId + '-slider')
      chart.dom.slider.slider({
        range: true
        min: 1
        max: chart.vars.maxXProp
        values: [1, chart.vars.maxXProp]
        change: chart.draw
        slide: chart.setSliderValues
        stop: chart.setSliderValues
      })

    chart.setSliderValues = ->
      transformToLogValue = (sliderValue)->
        minp = 1
        maxp = chart.vars.maxXProp
        minv = Math.log 1
        maxv = Math.log chart.vars.maxXProp

        # calculate adjustment factor
        factor = (maxv-minv) / (maxp-minp)
        Math.exp(minv + factor * (sliderValue-minp))

      chart.vars.sliderValues = chart.dom.slider.slider('values')
      _.each chart.vars.sliderValues, (value, index)->
        transformedValue = Math.floor transformToLogValue(value)
        $('#' + chart.vars.elId + '-slider-val-' + index).html transformedValue
        chart.vars.sliderValues[index] = transformedValue

    chart.setScales = ->
      chart.scales.x = d3.scale.log()
        .domain [chart.vars.sliderValues[0] - 0.5, chart.vars.sliderValues[1] + 1]
        .range [0, chart.cg.width - chart.cg.margin.left - 20]

      chart.scales.y = d3.scale.log()
        .domain [0.5, chart.vars.maxFilesCount]
        .rangeRound [0, (-1) * (chart.cg.height - chart.vars.verticalMargin - 20)]

    chart.createChart = ->
      previousSvg = d3.select('#' + chart.vars.elId + ' svg')
      previousSvg.remove() if previousSvg
      chart.dom.svg = d3.select('#' + chart.vars.elId)
        .attr 'class', 'chart-distribution-bars'
        .append('svg')
        .attr({width: chart.cg.width, height: chart.cg.height})
      chart.dom.chart = chart.dom.svg.append('g')
        .attr({transform: 'translate(' + chart.cg.margin.left + ',' + \
          chart.cg.margin.bottom + ')'})
    
    chart.createAxis = ->
      chart.dom.xAxis = d3.svg.axis().scale(chart.scales.x)
        .orient('bottom')
        .tickFormat((d)->
          # Digits different than zero (except first one)
          dString = d.toFixed(0).toString()
          digits = d % Math.pow(10, (dString.length) - 1)
          firstDigitOneTwoOrFive = dString[0] is '1' or dString[0] is '2' or dString[0] is '5'
          if digits is 0 and firstDigitOneTwoOrFive then return d
          else return null
        )

      chart.dom.yAxis = d3.svg.axis().scale(chart.scales.y)
        .orient('left')
        .ticks if chart.vars.maxFilesCount < 11 then chart.vars.maxFilesCount else 10
        .tickFormat((d)->
          # Digits different than zero (except first one)
          dString = d.toFixed(0).toString()
          digits = d % Math.pow(10, (dString.length) - 1)
          firstDigitOneTwoOrFive = dString[0] is '1' or dString[0] is '2' or dString[0] is '5'
          if digits is 0 and firstDigitOneTwoOrFive then return d
          else return null
        )
      
      chart.dom.chart.append('g')
        .attr({'transform': 'translate(0,' + chart.vars.floor + ')', class: 'x-axis axis'})
        .call(chart.dom.xAxis)
        .append('text')
        .attr('transform', 'translate(' + (chart.cg.width - chart.cg.margin.left) / 2 + ' ,0)')
        .attr('class', 'x-axis-label')
        .attr('y', 40).attr('font-size', '1.3em')
        .style({'text-anchor': 'end'})
        .text chart.cg.xLabel


      chart.dom.chart.append('g')
        .attr({'transform': 'translate(0,' + chart.vars.floor + ')', class: 'x-axis axis'})
        .call(chart.dom.yAxis)
        .append('text')
        .attr('transform', 'translate(-30,' + String((-1) * \
          (chart.cg.height - chart.cg.margin.bottom) / 2) + ')')
        .attr('y', 40)
        .attr('font-size', '1.3em')
        .style({'text-anchor': 'end'})
        .text('Files Count')

    chart.calcX = (d)-> chart.scales.x(d[chart.cg.xProp])
    chart.calcY = (d)-> chart.scales.y(d.filesCount) + chart.vars.floor
    chart.calcHeight = (d)-> chart.scales.y(d.filesCount) * (-1)

    chart.createBars = ->
      dataUsed = chart.data.filter((item, index)->
        if item[chart.cg.xProp] >= chart.vars.sliderValues[0] \
          and item[chart.cg.xProp] <= chart.vars.sliderValues[1] then return item
        else return null
      )
      
      dataUsed = _.compact dataUsed

      chart.dom.chart.selectAll('rect')
        .data(dataUsed)
        .enter()
        .append('rect')
        .attr 'x', (d)-> chart.calcX d
        .attr 'y', (d)-> chart.calcY d
        .attr 'width', 2
        .attr 'height', (d)-> chart.calcHeight d
        .attr('fill', (d)-> chart.vars.color(d.filesCount))
        .style 'filter', 'url(#' + chart.vars.elId + '-drop-shadow-filter)'

      chart.vars.points = []
      chart.dom.chart.selectAll('rect').each (d)->
        chart.vars.points.push chart.calcX(d)

    chart.render = (origData, opts, cb)->
      chart.vars.elId = opts.elId

      common.waitTillElPresent chart.vars.elId, ->
        chart.setData _.cloneDeep origData
        chart.setCg(opts)
        chart.setVars()
        chart.createSlider()
        chart.setSliderValues()
        chart.draw()
        cb() if cb

    chart.createFilter = ()->
      common.createSvgFilterBlack(chart.vars.elId + '-drop-shadow-filter', chart.dom.chart, 1, .6)

    chart.createMouseOverEvent = ()->
      foreground = chart.dom.svg.append('g')
        .attr 'id', 'foreground-' + chart.vars.elId
        .attr 'class', 'foreground'

      foreground.append('title').text('')
      
      foreground.append('rect')
        .attr('fill', 'green')
        .attr('stroke', 'black')
        .attr('class', 'title-rect')
        .attr 'x', chart.cg.margin.left
        .attr 'y', 0
        .attr 'width', (d, i)-> chart.cg.width - chart.cg.margin.left
        .attr 'height', chart.vars.floor + chart.cg.margin.bottom
        .style 'opacity', '0'
        .on 'mousemove', ()->
          # TODO: Improve performance of this algorithm
          mouse = d3.mouse(this)
          foregroundTitle = d3.select('#foreground-' + chart.vars.elId).select('title')
          x = d3.mouse(this)[0] - chart.cg.margin.left
          newPoints = angular.copy chart.vars.points
          newPoints = _.map newPoints, (point)-> Math.abs x - point
          minPoint = _.min newPoints
          index = newPoints.indexOf minPoint
          barsEl = chart.resetBarsColor()
          bar = barsEl[0][index]
          barEl = d3.select(bar)
          barEl.attr 'fill', '#C87200'
          barData = barEl.data()[0]
          titleText = barData.filesCount + ' file(s) with '
          titleText += barData[chart.cg.xProp] + ' ' + chart.cg.xTitle
          foregroundTitle.text titleText
        .on 'mouseleave', -> chart.resetBarsColor()
    
    chart.resetBarsColor = ->
      barsEl = chart.dom.chart.selectAll('rect')
      barsEl.attr 'fill', (d)-> chart.vars.color(d.filesCount)
      barsEl

    chart.draw = ()->
      chart.createChart()
      chart.setScales()
      chart.createAxis()
      chart.createBars()
      chart.createFilter()
      chart.createMouseOverEvent()
      
    chart

  createChart