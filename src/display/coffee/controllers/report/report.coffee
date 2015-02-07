define 'controllers/report/report', ->
  createController = (encina)->
    encina.controller 'ReportCtrl', ($scope, $http, $stateParams, EncinaFormatting)->
      $scope.report = $stateParams.report
      $http.get('/data/' + $scope.report + '.json').then (res)->
        $scope.data = res.data

        tmpParsedCharacs = []
        
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

        $scope.data.extensions.parsedHist
        $scope.data.extensions.parsedHist = []
        for extension in Object.keys($scope.data.extensions.hist)
          $scope.data.extensions.parsedHist.push({
            name: extension
            count: $scope.data.extensions.hist[extension]
            percentage: (100 * $scope.data.extensions.hist[extension] / \
              $scope.data.structure.total_files).toFixed(2)
          })
        $scope.data.extensions.parsedHist = _.sortBy($scope.data.extensions.parsedHist, \
          (obj)-> (-1) * obj.count)
        
        $scope.data.extensions.threeColumnsHist = \
          EncinaFormatting.split $scope.data.extensions.parsedHist, 3

        $scope.data.nel.parsedHist = []
        $scope.data.nel.total = 0
        for linesCount in Object.keys($scope.data.nel.hist)
          $scope.data.nel.total += linesCount * $scope.data.nel.hist[linesCount]
          $scope.data.nel.parsedHist.push({
            linesCount: Number(linesCount)
            filesCount: $scope.data.nel.hist[linesCount]
          })

        $scope.data.sizes.parsedHist = []
        $scope.data.sizes.totalMbs = ($scope.data.sizes.index_total / 1000000).toFixed(2)
        $scope.data.sizes.total = $scope.data.sizes.index_total / 1000000
        for size in Object.keys($scope.data.sizes.hist)
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

        dateTimestamp = moment.unix($scope.data.meta.time)
        $scope.data.meta.date = {
          day: dateTimestamp.format 'Do of MMMM (YYYY)'
          time: dateTimestamp.format 'HH:mm '
          short: dateTimestamp.format 'YYYY/MM/DD - HH:mm'
        }

        _.each $scope.data.extensions.hist_by_size, (item)-> item[1] = item[1] / 1000

        addKeysToExtensionsHists = (dataArray, sum)->
          dataArray = _.map dataArray, (item)-> {name: item[0], count: item[1]}
          _.each dataArray, (item)-> item.percentage = ((item.count / sum) * 100).toFixed 2
          dataArray

        $scope.data.extensions.hist_by_nel = \
          addKeysToExtensionsHists $scope.data.extensions.hist_by_nel, \
          $scope.data.nel.total
        
        $scope.data.extensions.hist_by_size = \
          addKeysToExtensionsHists $scope.data.extensions.hist_by_size, \
          $scope.data.sizes.index_total / 1000

        angular.element(document).ready ->
          show = (elId)->
            container = document.getElementById elId
            angular.element(container).css 'opacity', 1
          show 'report-container'

  createController