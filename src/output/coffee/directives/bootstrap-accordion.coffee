define 'directives/bootstrap-accordion', [], ()->
  create = (encina)->
    encina.directive 'bootstrapAccordion', ->
      return {
        restrict: 'E'
        templateUrl: 'components/bootstrap-accordion.html'
        replace: true
        scope:
          titleText: '@'
          expanded: '@'
          name: '@'
        transclude: true
      }
  create