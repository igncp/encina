define 'directives/bootstrap-modal-default-list', [], ()->
  create = (encina)->
    encina.directive 'bootstrapModalDefaultList', (EncinaUtils)->
      return {
        restrict: 'E'
        templateUrl: '/components/bootstrap-modal-default-list.html'
        replace: true
        scope:
          varArray: '='
          varName: '@'
          modalTitle: '@'
          modalNumber: '@'
          labelTitle: '@'
        transclude: false
        link: (scope, elem, attr)->
          scope.launchModal = EncinaUtils.launchModal
      }
  create