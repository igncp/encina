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
    
    $scope.treeDirString = JSON.stringify $scope.data.treeDir, undefined, 2
    console.log '$scope.data', $scope.data