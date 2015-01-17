define 'controllers/conclusions', ->
  createController = (encina)->
    encina.controller 'ConclusionsCtrl', ($scope)->
      $scope.conclusions = []
      console.log '$scope.conclusions', $scope.conclusions

  createController