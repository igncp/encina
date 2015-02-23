define 'directives/home-project-row-name', [], ->
  create = (encina)->
    encina.directive 'homeProjectRowName', (EncinaUtils)->
      # Directive made to know when the ng-repeat is finished
      # and apply the animations
      return {
        restrict: 'A'
        template: '<div ng-transclude></div>'
        replace: false
        transclude: true
        link: (scope, elem, attr)->
          if scope.$last is true
            rows = document.querySelectorAll '.home-project-row'
            console.log 'rows', rows
            _.each rows, (row)->
              tds = row.querySelectorAll 'td'
              row.addEventListener 'mouseenter', ->
                _.each tds, (td)->
                  Velocity td, {
                    'padding-top': 30
                    'padding-bottom': 30
                  }, {duration: 500, queue: false}
              row.addEventListener 'mouseleave', ->
                _.each tds, (td)->
                  Velocity td, {
                    'padding-top': 8
                    'padding-bottom': 8
                  }, {duration: 500, queue: false}
      }
  create