define 'directives/directives', [
  'directives/summary-statistics'
  'directives/bootstrap-accordion'
  'directives/bootstrap-modal'
], ()->
  directives = arguments
  createDirectives = (encina)->
    angular.forEach directives, (directive)-> directive(encina)

  createDirectives