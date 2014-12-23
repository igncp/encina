define 'app', ['charts/charts'], ->
  encina = angular.module('encina', [])

  encina.controller 'MainCtrl', ($scope, $http)->
    $http.get('data.json').then (res)->
      $scope.data = res.data
      
      $scope.data.parsedExtensions = []
      for extension in Object.keys($scope.data.extensions)
        $scope.data.parsedExtensions.push({
          name: extension
          count: $scope.data.extensions[extension]
        })

      $scope.data.parsedLines = []
      $scope.data.totalLines = 0
      for linesCount in Object.keys($scope.data.lines)
        $scope.data.totalLines += Number(linesCount) * \
          Number($scope.data.lines[linesCount])
        $scope.data.parsedLines.push({
          linesCount: Number(linesCount)
          filesCount: Number($scope.data.lines[linesCount])
        })

      $scope.data.parsedSizes = []
      $scope.data.totalSize = 0
      for size in Object.keys($scope.data.sizes)
        $scope.data.totalSize += Number(size) * \
          Number($scope.data.sizes[size]) / 131072
        $scope.data.parsedSizes.push({
          size: Number(size)
          filesCount: Number($scope.data.sizes[size])
        })
      
      $scope.treeDirString = JSON.stringify $scope.data.treeDir, undefined, 2
      $scope.loaded = -> document.body.style.opacity = 1

      (require('charts/extensions-pie')).render($scope.data.parsedExtensions)
      
      console.log '$scope.data', $scope.data

  encina.directive 'bootstrapAccordion', ->
    return {
      restrict: 'E'
      templateUrl: 'components/bootstrap-accordion.html'
      replace: true
      scope:
        title: '@'
        expanded: '@'
        name: '@'
      transclude: true
    }

  angular.bootstrap document, ['encina']