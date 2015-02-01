define 'directives/bootstrap-modal', [], ()->
  create = (encina)->
    encina.directive 'bootstrapModal', ->
      return {
        restrict: 'E'
        templateUrl: '/components/bootstrap-modal.html'
        replace: true
        scope:
          varName: '@'
          modalTitle: '@'
          modalNumber: '@'
        transclude: true
      }
  create