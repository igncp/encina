define 'charts/defaults/radial-graph', ['charts/common'], (common)->
  createChart = ->
    chart = {
      vars: {}
      dom: {}
      scales: {}
    }

    chart.setCg = (title)->
      chart.cg = {
        title: title
        height: 600
        margin: {left: 10, bottom: 10, top: 10}
        colorsArr: ['#323247','#7C7CC9','#72B66C','#429742']
        heavyComputationLimit: 500
        transitionDuration: 500
        factors:
          graphCols: 9 # of 12 (bootstrap)
        node:
          radius: 5
          radiusMouse: 15
        force:
          charge: -70
          linkDistance: 50
      }

      chart.cg.width = chart.vars.elWidth * (chart.cg.factors.graphCols / 12)
    
    chart.setVarsPreCg = ->
      chart.vars.elWidth = $('#' + chart.vars.elId).width()
      chart.vars.panelId = chart.vars.elId + '-panel'
      chart.vars.el = d3.select "##{chart.vars.elId}"

    chart.setVarsPostCg = (title)->
      chart.vars.chartHeight = chart.cg.height - chart.cg.margin.top - chart.cg.margin.bottom
      chart.vars.chartWidth = chart.cg.width - chart.cg.margin.left - chart.cg.margin.top
      chart.vars.force = d3.layout.force()
        .charge chart.cg.force.charge
        .linkDistance chart.cg.force.linkDistance
        .size [chart.cg.width, chart.cg.height]
    
    chart.setData = (data)-> chart.data = data

    chart.drawBase = ->
      chart.dom.svg = chart.vars.el
        .attr class: 'chart-radial-graph'
        .text ''
        .append 'svg'
        .attr
          width: chart.cg.width
          height: chart.cg.height
          class: 'col-lg-' + chart.cg.factors.graphCols
      
      chart.dom.chart = chart.dom.svg.append('g')
        .attr({transform: 'translate(' + chart.cg.margin.left + ',' + \
          chart.cg.margin.bottom + ')'})

    chart.transformTreeDataToNodesAndLinks = (origData)->
      nodes = []
      links = []
      extractNodesAndLinks = (node, sourceIndex, sourceNode)->
        nodes.push _.omit(node, 'children')
        lastNode = _.last nodes
        lastNode.parent = sourceNode if sourceNode
        lastNode.children = node.children
        newNodeIndex = (nodes.length - 1)
        if sourceIndex isnt false then links.push {source: sourceIndex, target: newNodeIndex}
        _.each node.children, (child)->
          extractNodesAndLinks child, newNodeIndex, lastNode

      extractNodesAndLinks origData, false, false
      data =
        nodes: nodes
        links: links
      
      data

    chart.limitForce =
      x: (x)->
        if x > chart.vars.chartWidth then return chart.vars.chartWidth
        else if x < 0 then return 0
        else return x
      y: (y)->
        if y > chart.vars.chartHeight then return chart.vars.chartHeight
        else if y < 0 then return 0
        else return y

    chart.drawPanel = ->
      chart.dom.panel = chart.vars.el.append 'div'
        .attr
          id: chart.vars.panelId
          class: "chart-radial-graph-panel col-lg-#{12 - chart.cg.factors.graphCols}"
          style: "height: #{chart.cg.height}px"
      
      chart.dom.panelList = chart.dom.panel.append 'ul'
        .attr
          class: 'chart-radial-graph-panel-list'

    chart.drawGraph = ->
      chart.vars.force.nodes chart.data.nodes
        .links chart.data.links
        .start()

      chart.dom.links = chart.dom.chart.selectAll '.link'
        .data chart.data.links
        .enter().append 'line'
        .attr class: 'link'

      chart.dom.nodes = chart.dom.chart.selectAll '.node'
        .data chart.data.nodes
        .enter().append 'circle'
        .attr
          class: ((d)->
            finalClass = 'node'
            if d.index is 0 then finalClass += ' node-root'
            if d.type is 'directory' then finalClass += ' node-dir'
            if d.type is 'file' then finalClass += ' node-file'
            finalClass
          )
          id: (d, i)-> nodeIndex = "#{chart.vars.elId}-node-#{i}"
        .attr r: chart.cg.node.radius
        .call chart.vars.force.drag
      
      chart.dom.nodes.each (d)-> d.nodeId = "##{d3.select(@).attr('id')}"

      chart.setForceListeners()
      chart.setNodeListeners()

    chart.setForceListeners = ->
      chart.vars.force.on 'tick', ->
        chart.dom.links.attr
          x1: (d)-> chart.limitForce.x(d.source.x)
          y1: (d)-> chart.limitForce.y(d.source.y)
          x2: (d)-> chart.limitForce.x(d.target.x)
          y2: (d)-> chart.limitForce.y(d.target.y)

        chart.dom.nodes.attr
          cx: (d)-> chart.limitForce.x(d.x)
          cy: (d)-> chart.limitForce.y(d.y)

    chart.setNodeListeners = ->
      previousD = ''
      changeRadiusToSelfAndParents = (nodeData, panelAction, radius)->
        if nodeData.parent
          changeRadiusToSelfAndParents nodeData.parent, panelAction, radius
          nodeType = nodeData.type
        else
          nodeType = 'root'

        node = d3.select nodeData.nodeId
        if panelAction is 'add'
          listItem = chart.dom.panelList.append 'li'
            .attr
              class: nodeType
          
          listItem.append 'p'
            .text nodeData.name
          
          if nodeType is 'file'
            listItem.append 'p'
              .text "(#{Number(nodeData.size / 1000).toFixed(2)} kbs | " + \
                "#{nodeData.lines} non empty lines of code)"
          else
            files = nodeData.children.filter((item)-> item.type is 'file').length
            dirs = nodeData.children.filter((item)-> item.type is 'directory').length
            listItem.append 'p'
              .text "(dirs: #{dirs} | files: #{files})"

        node.transition()
          .duration chart.cg.transitionDuration
          .attr r: radius
      
      chart.dom.nodes.on 'mouseenter', (d)->
        if previousD
          changeRadiusToSelfAndParents previousD, 'remove', chart.cg.node.radius
        chart.dom.panelList.text ''
        chart.dom.panelList.style opacity: 1
        changeRadiusToSelfAndParents d, 'add', chart.cg.node.radiusMouse
        previousD = d
      

    chart.draw = ->
      chart.drawBase()
      chart.drawPanel()
      chart.drawGraph()

    chart.render = (origData, id, title)->
      chart.vars.elId = id

      common.waitTillElPresent chart.vars.elId, ->
        chart.setData _.cloneDeep origData
        chart.setVarsPreCg()
        chart.setCg(title)
        chart.setVarsPostCg()
        if chart.data.nodes.length > chart.cg.heavyComputationLimit
          advice = d3.select "##{chart.vars.elId}-advice"
          advice.style display: 'block'
            .select 'a'
            .on 'click', ->
              advice.style display: 'none'
              chart.draw()
        else chart.draw()

    chart

  createChart