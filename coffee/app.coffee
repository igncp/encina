define 'app', [], ->
  encinaSite = angular.module('encinaSite', [])

  encinaSite.controller 'MainCtrl', ($scope)->
    $scope.loaded = ->
      el = document.getElementById 'container'
      angular.element(el).css 'opacity', 1
      false # To avoid returning the DOM element

  angular.bootstrap document, ['encinaSite']