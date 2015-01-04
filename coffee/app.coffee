define 'app', [], ->
  encinaSite = angular.module('encinaSite', [])

  encinaSite.controller 'MainCtrl', ($scope)->
    angular.element(document).ready ->
      show = (elId)->
        el = document.getElementById elId
        angular.element(el).css 'opacity', 1
      
      show 'container'
      show 'footer'
      false # To avoid returning the DOM element

  angular.bootstrap document, ['encinaSite']