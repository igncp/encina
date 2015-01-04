define 'app', ['charts/charts'], ->
  encina = angular.module('encina', [])

  encina.controller 'MainCtrl', ($scope, $http, $timeout)->
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
      
      $scope.treeString = JSON.stringify $scope.data.tree, undefined, 2
      
      $scope.bsToKbs = (size, decimals = 2)-> (size / 1000).toFixed(decimals) + ' kbs'

      $scope.nbrWCommas = (x)->
        parts = x.toString().split '.'
        parts[0] = parts[0].replace /\B(?=(\d{3})+(?!\d))/g, ','
        parts.join '.'
        
      renderCharts = (cb)->
        async.parallel [
          (end)-> (require('charts/extensions-pie'))($scope.data.extensions.parsedHist, end)
          (end)-> (require('charts/lines-distribution')).render($scope.data.nel.parsedHist, end)
        ], cb

      angular.element(document).ready ->
        # Need to wait till all directives containing charts are rendered
        async.series [renderCharts, (end)->
          show = (elId)->
            container = document.getElementById elId
            angular.element(container).css 'opacity', 1

          show 'container'
          show 'footer'
          end()
        ]
        false

  encina.directive 'bootstrapAccordion', ->
    return {
      restrict: 'E'
      templateUrl: 'components/bootstrap-accordion.html'
      replace: true
      scope:
        titleText: '@'
        expanded: '@'
        name: '@'
      transclude: true
    }

  angular.bootstrap document, ['encina']