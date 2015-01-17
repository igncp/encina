define 'controllers/main', ->
  createController = (encina)->
    encina.controller 'MainCtrl', ($scope, $http)->
      $http.get('data.json').then (res)->
        $scope.data = res.data
        angular.element(document).ready ->
          show = (elId)->
            container = document.getElementById elId
            angular.element(container).css 'opacity', 1
          show 'container'
          show 'footer'
          console.log '$scope.data', $scope.data

  createController