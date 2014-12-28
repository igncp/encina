define 'app', ['charts/charts'], ->
  encina = angular.module('encina', [])

  encina.controller 'MainCtrl', ($scope, $http)->
    $http.get('data.json').then (res)->
      $scope.data = res.data

      $scope.data.extensions.parsedHist = []
      for extension in Object.keys($scope.data.extensions.hist)
        $scope.data.extensions.parsedHist.push({
          name: extension
          count: $scope.data.extensions.hist[extension]
        })

      $scope.data.nel.parsedHist = []
      $scope.data.nel.total = 0
      for linesCount in Object.keys($scope.data.nel.hist)
        $scope.data.nel.total += linesCount * $scope.data.nel.hist[linesCount]
        $scope.data.nel.parsedHist.push({
          linesCount: linesCount
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
      
      (require('charts/extensions-pie')).render($scope.data.extensions.parsedHist)
      (require('charts/lines-distribution')).render($scope.data.nel.parsedHist)
      
      console.log '$scope.data', $scope.data
      $scope.loaded = -> document.body.style.opacity = 1

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