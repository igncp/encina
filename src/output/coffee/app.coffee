encina = angular.module('encina', [])

encina.controller 'MainCtrl', ($scope, $http)->
  $http.get('data.json').then (res)->
    $scope.data = res.data
    console.log '$scope.data', $scope.data