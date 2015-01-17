define 'controllers/home', ->
  createController = (encina)->
    encina.controller 'HomeController', ($scope, $timeout)->
      runController = ->
        $scope.data = $scope.$parent.data
        $scope.nbrWCommas = (x, decimals = 0)->
          x = x.toFixed(decimals)
          parts = x.toString().split '.'
          final = parts[0] = parts[0].replace /\B(?=(\d{3})+(?!\d))/g, ','
          final = parts.join '.'

        tmpParsedCharacs = []
        delete $scope.data.characteristics.parsed
        explanationsTpls =
          dir: (s)-> 'The directory ' + s + ' was found.'
          file: (s)-> 'The file ' + s + ' was found.'
          extension: (s)-> 'One or more files with the extension .' + s + ' were found.'
        for type in Object.keys($scope.data.characteristics)
          for charac in Object.keys($scope.data.characteristics[type])
            tmpParsedCharacs.push {
              desc: $scope.data.characteristics[type][charac]
              explanation: explanationsTpls[type](charac)
            }
        $scope.data.characteristics.parsed = []
        $scope.data.characteristics.parsed.push(tmpParsedCharacs.splice(0, \
          Math.ceil(tmpParsedCharacs.length / 2)))
        $scope.data.characteristics.parsed.push tmpParsedCharacs

        $scope.data.extensions.parsedHist = []
        for extension in Object.keys($scope.data.extensions.hist)
          $scope.data.extensions.parsedHist.push({
            name: extension
            count: $scope.data.extensions.hist[extension]
            percentage: (100 * $scope.data.extensions.hist[extension] / \
              $scope.data.structure.total_files).toFixed(2)
          })

        $scope.data.nel.parsedHist = []
        $scope.data.nel.total = 0
        for linesCount in Object.keys($scope.data.nel.hist)
          $scope.data.nel.total += linesCount * $scope.data.nel.hist[linesCount]
          $scope.data.nel.parsedHist.push({
            linesCount: Number(linesCount)
            filesCount: $scope.data.nel.hist[linesCount]
          })

        $scope.data.sizes.parsedHist = []
        $scope.data.sizes.total = 0
        for size in Object.keys($scope.data.sizes.hist)
          $scope.data.sizes.total += size * $scope.data.sizes.hist[size] / 131072
          $scope.data.sizes.parsedHist.push({
            size: size
            filesCount: $scope.data.sizes.hist[size]
          })

        $scope.data.depths.parsedHist = []
        $scope.data.depths.total = 0
        for depthLevel in Object.keys($scope.data.depths.hist)
          $scope.data.depths.parsedHist.push({
            depthLevel: Number(depthLevel)
            filesCount: $scope.data.depths.hist[depthLevel]
          })
        
        $scope.treeString = JSON.stringify $scope.data.tree, undefined, 2
        
        $scope.bsToKbs = (size, decimals = 2)-> (size / 1000).toFixed(decimals) + ' kbs'

        $scope.data.meta.date = {
          day: moment.unix($scope.data.meta.time).format 'Do of MMMM (YYYY)'
          time: moment.unix($scope.data.meta.time).format 'HH:mm '
        }
        
        renderCharts = ()->
          (require('charts/extensions-pie'))($scope.data.extensions.parsedHist)
          (require('charts/lines-distribution'))($scope.data.nel.parsedHist)
          (require('charts/depths-distribution'))($scope.data.depths.parsedHist)

        renderCharts()

      waitTillDataLoaded = ->
        if $scope.$parent.data then runController()
        else $timeout(waitTillDataLoaded, 50)
      waitTillDataLoaded()

  createController
