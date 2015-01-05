define 'app', [
  'charts/charts'
  'directives/directives'
], (charts, directives)->
  encina = angular.module('encina', [])

  mainCtrl = encina.controller 'MainCtrl', ($scope, $http, $timeout)->
    $http.get('data.json').then (res)->
      $scope.data = res.data

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
      
        
      renderCharts = (cb)->
        async.parallel [
          (end)-> (require('charts/extensions-pie'))($scope.data.extensions.parsedHist, end)
          (end)-> (require('charts/lines-distribution'))($scope.data.nel.parsedHist, end)
          (end)-> (require('charts/depths-distribution'))($scope.data.depths.parsedHist, end)
        ], cb

      angular.element(document).ready ->
        # Need to wait till all directives containing charts are rendered
        async.series [renderCharts, (end)->
          show = (elId)->
            container = document.getElementById elId
            angular.element(container).css 'opacity', 1

          show 'container'
          show 'footer'
          console.log '$scope.data', $scope.data
          end()
        ]
        false

  # Creates directives
  directives(mainCtrl)

  angular.bootstrap document, ['encina']