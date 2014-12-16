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
    console.log '$scope.data', $scope.data