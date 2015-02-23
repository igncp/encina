define 'directives/home-project-row-name', [], ->
  create = (encina)->
    encina.directive 'homeProjectRowName', (EncinaUtils)->
      # Directive made to know when the ng-repeat is finished
      # and apply the listeners to the elements
      return {
        restrict: 'A'
        template: '<div ng-transclude></div>'
        replace: false
        transclude: true
        link: (scope, elem, attr)->
          changeVerticalPaddingsToTds = (tds, value)->
            _.each tds, (td)->
              Velocity td, {
                'padding-top': value
                'padding-bottom': value
              }, {duration: 500, queue: false}
          if scope.$last is true
            rows = document.querySelectorAll '.home-project-row'
            _.each rows, (row)->
              tds = row.querySelectorAll 'td'
              row.addEventListener 'mouseenter', ->
                changeVerticalPaddingsToTds tds, 30
              row.addEventListener 'mouseleave', ->
                changeVerticalPaddingsToTds tds, 8
      }
  create